const { format } = require('date-fns');

module.exports = function(eleventyConfig) {
  // Copy the `assets` directory to the output
  eleventyConfig.addPassthroughCopy("assets");

  // Date formatting filter
  eleventyConfig.addFilter("formatPostDate", (dateObj) => {
    // Format: 18th Jan 2024
    return format(dateObj, 'do MMM yyyy');
  });

  return {
    // When a default layout is not specified,
    // Eleventy will look for a file with the same name
    // as the post's directory.
    dir: {
      layouts: "_layouts"
    }
  };
};