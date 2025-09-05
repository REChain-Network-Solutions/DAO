# Accessibility Guide

## Overview

This guide provides comprehensive accessibility standards and implementation guidelines for the REChain DAO platform to ensure it's usable by people with disabilities.

## Table of Contents

1. [WCAG Compliance](#wcag-compliance)
2. [Keyboard Navigation](#keyboard-navigation)
3. [Screen Reader Support](#screen-reader-support)
4. [Color and Contrast](#color-and-contrast)
5. [Focus Management](#focus-management)
6. [Semantic HTML](#semantic-html)
7. [ARIA Implementation](#aria-implementation)
8. [Testing and Validation](#testing-and-validation)
9. [Best Practices](#best-practices)

## WCAG Compliance

### Level AA Standards

#### Perceivable
- **Text Alternatives**: All images have alt text
- **Captions**: Video content has captions
- **Color Independence**: Information not conveyed by color alone
- **Resizable Text**: Text can be resized up to 200%

#### Operable
- **Keyboard Accessible**: All functionality available via keyboard
- **No Seizures**: No content flashes more than 3 times per second
- **Navigable**: Users can navigate and find content

#### Understandable
- **Readable**: Text is readable and understandable
- **Predictable**: Web pages appear and operate predictably
- **Input Assistance**: Users are helped to avoid and correct mistakes

#### Robust
- **Compatible**: Content is compatible with assistive technologies

## Keyboard Navigation

### Tab Order
```css
/* Ensure logical tab order */
.tab-focus {
  outline: 2px solid var(--primary-500);
  outline-offset: 2px;
}

/* Skip links for main content */
.skip-link {
  position: absolute;
  top: -40px;
  left: 6px;
  background: var(--primary-600);
  color: white;
  padding: 8px;
  text-decoration: none;
  z-index: 1000;
}

.skip-link:focus {
  top: 6px;
}
```

### Keyboard Shortcuts
- **Tab**: Move to next focusable element
- **Shift + Tab**: Move to previous focusable element
- **Enter/Space**: Activate buttons and links
- **Escape**: Close modals and dropdowns
- **Arrow Keys**: Navigate within menus and lists

## Screen Reader Support

### Semantic HTML
```html
<!-- Proper heading structure -->
<h1>Main Page Title</h1>
  <h2>Section Title</h2>
    <h3>Subsection Title</h3>

<!-- Form labels -->
<label for="username">Username</label>
<input type="text" id="username" name="username" required>

<!-- Button descriptions -->
<button aria-label="Close dialog">×</button>

<!-- Table headers -->
<table>
  <thead>
    <tr>
      <th scope="col">Name</th>
      <th scope="col">Email</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th scope="row">John Doe</th>
      <td>john@example.com</td>
    </tr>
  </tbody>
</table>
```

### ARIA Labels
```html
<!-- Navigation landmarks -->
<nav aria-label="Main navigation">
  <ul>
    <li><a href="/home">Home</a></li>
    <li><a href="/about">About</a></li>
  </ul>
</nav>

<!-- Form validation -->
<input type="email" aria-describedby="email-error" aria-invalid="true">
<div id="email-error" role="alert">Please enter a valid email address</div>

<!-- Live regions for dynamic content -->
<div aria-live="polite" id="status-messages"></div>
<div aria-live="assertive" id="error-messages"></div>
```

## Color and Contrast

### Contrast Ratios
- **Normal Text**: Minimum 4.5:1 contrast ratio
- **Large Text**: Minimum 3:1 contrast ratio
- **UI Components**: Minimum 3:1 contrast ratio

### Color Independence
```css
/* Don't rely on color alone */
.error {
  color: var(--error-600);
  border: 2px solid var(--error-600);
  background-color: var(--error-50);
}

/* Use icons and text with color */
.status-success::before {
  content: "✓ ";
  color: var(--success-600);
}

.status-error::before {
  content: "✗ ";
  color: var(--error-600);
}
```

## Focus Management

### Focus Indicators
```css
/* Visible focus indicators */
.focus-visible {
  outline: 2px solid var(--primary-500);
  outline-offset: 2px;
}

/* Remove focus outline for mouse users */
.focus-visible:not(:focus-visible) {
  outline: none;
}
```

### Focus Trapping
```javascript
// Focus trap for modals
class FocusTrap {
  constructor(element) {
    this.element = element;
    this.focusableElements = this.getFocusableElements();
    this.firstFocusable = this.focusableElements[0];
    this.lastFocusable = this.focusableElements[this.focusableElements.length - 1];
  }
  
  trap(event) {
    if (event.key === 'Tab') {
      if (event.shiftKey) {
        if (document.activeElement === this.firstFocusable) {
          event.preventDefault();
          this.lastFocusable.focus();
        }
      } else {
        if (document.activeElement === this.lastFocusable) {
          event.preventDefault();
          this.firstFocusable.focus();
        }
      }
    }
  }
  
  getFocusableElements() {
    return this.element.querySelectorAll(
      'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])'
    );
  }
}
```

## Semantic HTML

### Proper Structure
```html
<!-- Main content structure -->
<main>
  <header>
    <h1>Page Title</h1>
    <nav aria-label="Breadcrumb">
      <ol>
        <li><a href="/">Home</a></li>
        <li><a href="/posts">Posts</a></li>
        <li aria-current="page">Current Post</li>
      </ol>
    </nav>
  </header>
  
  <section aria-labelledby="posts-heading">
    <h2 id="posts-heading">Recent Posts</h2>
    <article>
      <h3>Post Title</h3>
      <p>Post content...</p>
    </article>
  </section>
  
  <aside aria-labelledby="sidebar-heading">
    <h2 id="sidebar-heading">Sidebar</h2>
    <!-- Sidebar content -->
  </aside>
</main>
```

### Form Accessibility
```html
<!-- Accessible form -->
<form>
  <fieldset>
    <legend>User Information</legend>
    
    <div class="form-group">
      <label for="firstname">First Name *</label>
      <input type="text" id="firstname" name="firstname" required
             aria-describedby="firstname-help">
      <div id="firstname-help" class="help-text">
        Enter your first name
      </div>
    </div>
    
    <div class="form-group">
      <label for="email">Email Address *</label>
      <input type="email" id="email" name="email" required
             aria-describedby="email-error" aria-invalid="false">
      <div id="email-error" class="error-text" role="alert" aria-live="polite">
        <!-- Error messages appear here -->
      </div>
    </div>
    
    <button type="submit">Submit</button>
  </fieldset>
</form>
```

## ARIA Implementation

### ARIA Labels and Descriptions
```html
<!-- Button with description -->
<button aria-describedby="save-help">Save</button>
<div id="save-help">Saves your changes to the server</div>

<!-- Complex widget -->
<div role="tablist" aria-label="User settings">
  <button role="tab" aria-selected="true" aria-controls="profile-panel">
    Profile
  </button>
  <button role="tab" aria-selected="false" aria-controls="account-panel">
    Account
  </button>
</div>

<div role="tabpanel" id="profile-panel" aria-labelledby="profile-tab">
  <!-- Profile content -->
</div>
```

### Live Regions
```html
<!-- Status updates -->
<div aria-live="polite" id="status-updates">
  <!-- Status messages appear here -->
</div>

<!-- Error announcements -->
<div aria-live="assertive" id="error-announcements">
  <!-- Critical errors appear here -->
</div>
```

## Testing and Validation

### Automated Testing
```javascript
// Accessibility testing with axe-core
import { axe, toHaveNoViolations } from 'jest-axe';

expect.extend(toHaveNoViolations);

test('should not have accessibility violations', async () => {
  const { container } = render(<MyComponent />);
  const results = await axe(container);
  expect(results).toHaveNoViolations();
});
```

### Manual Testing
1. **Keyboard Navigation**: Test all functionality with keyboard only
2. **Screen Reader**: Test with screen reader software
3. **Color Blindness**: Test with color blindness simulators
4. **Zoom**: Test with 200% zoom level

### Testing Tools
- **axe-core**: Automated accessibility testing
- **WAVE**: Web accessibility evaluation tool
- **Lighthouse**: Chrome accessibility audit
- **NVDA/JAWS**: Screen reader testing

## Best Practices

### Development Guidelines
1. **Semantic HTML**: Use proper HTML elements
2. **ARIA When Needed**: Use ARIA to enhance, not replace, semantic HTML
3. **Test Early**: Test accessibility throughout development
4. **User Testing**: Include users with disabilities in testing

### Content Guidelines
1. **Clear Language**: Use clear, simple language
2. **Descriptive Links**: Use descriptive link text
3. **Alt Text**: Write meaningful alt text for images
4. **Headings**: Use proper heading hierarchy

### Design Guidelines
1. **High Contrast**: Ensure sufficient color contrast
2. **Large Touch Targets**: Make interactive elements at least 44px
3. **Consistent Navigation**: Keep navigation consistent
4. **Error Prevention**: Help users avoid and correct errors

## Conclusion

This accessibility guide ensures the REChain DAO platform is usable by everyone, including people with disabilities. Following these guidelines creates an inclusive experience for all users.

Remember: Accessibility is not a one-time implementation; it requires ongoing attention and testing to maintain compliance and usability.
