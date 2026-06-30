# Varify A/B Testing — GTM Web Tag Template

A Google Tag Manager web tag template for [Varify](https://varify.io) A/B testing. Load the Varify snippet, configure consent-aware tracking, and capture experiment data in the dataLayer.

## Features

- **Script Loading** — Load the Varify A/B testing script with your instance ID
- **Consent-Aware Tracking** — Optional consent mode that defers dataLayer events until `varify.setTracking(true)` is called
- **DataLayer Integration** — Varify automatically pushes experiment data to the dataLayer (event name: `varify`) with parameters like `varify_abTestShort`, `varify_experimentId`, `varify_variationId`

## Setup

### 1. Load the Varify Script (All Pages)

1. Create a new tag using the **Varify A/B Testing** template
2. Enter your **Instance ID** (found in your Varify dashboard)
3. Optionally enable **consent-aware tracking** if using a CMP
4. Set the trigger to **All Pages** (or Consent Initialization if using consent mode)

### 2. Capture Experiment Data in GA4

1. Create a **Data Layer Variable** named `varify_abTestShort`
2. Create a **Custom Event Trigger** for event name `varify`
3. Create a **GA4 Event Tag**:
   - Event name: `Abtesting`
   - Parameter: `varify_abTestShort` = `{{varify_abTestShort}}`
4. In GA4 Admin, create a custom dimension "Varify AB Test" with event parameter `varify_abTestShort`

### Consent Mode

When **consent-aware tracking** is enabled:
- Varify will load but won't push events to the dataLayer
- You need to call `varify.setTracking(true)` after consent is granted
- Use a **Custom HTML tag** with this code, triggered after consent:

```html
<script>
if (window.varify && typeof window.varify.setTracking === 'function') {
  window.varify.setTracking(true);
} else {
  window.addEventListener('varify:loaded', function() {
    window.varify.setTracking(true);
  });
}
</script>
```

## DataLayer Event

When a visitor enters an experiment, Varify pushes:

```javascript
{
  event: "varify",
  varify_experimentId: 123,
  varify_experimentName: "Homepage Hero Test",
  varify_variationId: 456,
  varify_variationName: "Variant A",
  varify_abTestShort: "123:456"
}
```

## Permissions

- **Inject Scripts** — Loads `https://app.varify.io/varify.js`
- **Access Global Variables** — Read/write `window.varify` for configuration and tracking activation
- **Logging** — Console logging in debug/preview mode only

## Resources

- [Varify GTM Documentation](https://varify.io/en/userdocumentation/tracking-with-gtm-google-tag-manager/)
- [Varify Documentation](https://varify.io/en/userdocumentation/)

## Author

Created and maintained by [Freek Kampen](https://freekkampen.com) at [New North Digital](https://newnorth.digital?utm_source=github&utm_medium=gtm-template&utm_campaign=varify-web-tag)

## License

Apache 2.0 — see [LICENSE](LICENSE).
