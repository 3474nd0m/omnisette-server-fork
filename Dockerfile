FROM rust:slim-bookworm AS builder
WORKDIR /app
RUN apt-get update && apt-get install --no-install-recommends -y perl make unzip curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
COPY Cargo.* ./
COPY src ./src
RUN cargo build --release

# Download the Apple Music APK and extract the two .so files omnisette needs
RUN curl -L https://apps.mzstatic.com/content/android-apple-music-apk/applemusic.apk -o applemusic.apk && \
    unzip applemusic.apk 'lib/x86_64/libstoreservicescore.so' 'lib/x86_64/libCoreADI.so' -d /opt/omnisette-server/ && \
    rm applemusic.apk

FROM debian:stable-slim AS runtime
RUN apt-get update && apt-get install --no-install-recommends -y unzip curl ca-certificates bash && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY docker-entrypoint.sh ./
COPY --from=builder /opt/omnisette-server/target/release/omnisette-server ./
COPY --from=builder /opt/omnisette-server/lib ./lib
RUN chmod +x docker-entrypoint.sh
RUN chmod +x omnisette-server
ENTRYPOINT [ "./docker-entrypoint.sh" ]
