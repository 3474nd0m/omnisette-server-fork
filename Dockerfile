FROM rust:slim-bookworm AS builder
WORKDIR /app
RUN apt-get update && apt-get install --no-install-recommends -y perl make unzip curl && apt-get clean && rm -rf /var/lib/apt/lists/*
COPY Cargo.* ./
COPY src ./src
RUN cargo build --release
RUN curl -L https://apps.mzstatic.com/content/android-apple-music-apk/applemusic.apk -o applemusic.apk && unzip applemusic.apk "lib/x86_64/libstoreservicescore.so" "lib/x86_64/libCoreADI.so" -d /app/ && rm applemusic.apk

FROM debian:stable-slim AS runtime
RUN apt-get update && apt-get install --no-install-recommends -y unzip curl ca-certificates bash && apt-get clean && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY docker-entrypoint.sh /app/docker-entrypoint.sh
COPY --from=builder /app/target/release/omnisette-server /app/omnisette-server
COPY --from=builder /app/lib /app/lib
RUN chmod +x /app/docker-entrypoint.sh && chmod +x /app/omnisette-server
CMD ["/app/docker-entrypoint.sh"]
