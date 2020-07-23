module.exports = {
  docs: {
    "Simple PS Logger": ["introduction", "contributing"],
    "Getting Started": ["quick-start", "log-level", "configurations"],
    Providers: [
      {
        type: "doc",
        id: "simplepslogger.console",
      },
      {
        type: "doc",
        id: "simplepslogger.file",
      },
      {
        type: "doc",
        id: "simplepslogger.azloganalytics",
      },
    ],
    "Custom Providers": [
      "custom-providers-intro",
      "writing-custom-provider",
      "custom-provider-registration",
    ],
    References: [
      "commands/new-simplepslogger",
      "commands/get-simplepslogger",
      "commands/set-simplepslogger",
      "commands/remove-simplepslogger",
      "commands/write-log",
      "commands/clear-buffer",
      "commands/register-loggingprovider",
    ],
  },
};
