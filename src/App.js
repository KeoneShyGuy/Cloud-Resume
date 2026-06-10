import React, { useEffect, useState } from "react";

function App() {
  // React state is data that can change while the page is open.
  // When one of these values changes, React redraws the parts of the page that use it.
  const [name, setName] = useState("");
  const [submittedName, setSubmittedName] = useState("");
  const [visitorCount, setVisitorCount] = useState(null);
  const [counterError, setCounterError] = useState("");
  const [submitError, setSubmitError] = useState("");
  const [isSubmitting, setIsSubmitting] = useState(false);

  // useEffect runs after the page first loads.
  // The empty [] at the end means "run this once", which is what we want for a visitor counter.
  useEffect(() => {
    const updateVisitorCount = async () => {
      try {
        // In Azure Static Web Apps, /api/count maps to the Python Function route named "count".
        // Tip: if this fails in production, test /api/count directly in the browser first.
        const response = await fetch("/api/count");
        if (!response.ok) {
          throw new Error("Unable to update visitor counter.");
        }

        // The Function returns JSON like: { "counter": 12, "timestamp": "..." }.
        const data = await response.json();
        setVisitorCount(data.counter);
      } catch (error) {
        // Keep the page usable even if the counter API is down.
        setCounterError(error.message);
      }
    };

    updateVisitorCount();
  }, []);

  const handleSubmit = async (e) => {
    // Prevent the browser's default form behavior, which would reload the page.
    e.preventDefault();

    // Trim removes extra spaces so " Keone " becomes "Keone".
    const trimmedName = name.trim();
    if (!trimmedName) {
      setSubmitError("Please enter your name.");
      return;
    }

    // Disable the form while the request is running so the user does not double-click submit.
    setIsSubmitting(true);
    setSubmitError("");

    try {
      // Send the name to the Python Function as JSON.
      // The backend adds the timestamp so the client cannot fake when the record was saved.
      const response = await fetch("/api/nameSubmission", {
        method: "POST",
        headers: {
          "Content-Type": "application/json"
        },
        body: JSON.stringify({ name: trimmedName })
      });

      if (!response.ok) {
        throw new Error("Unable to save your name.");
      }

      // Only show the greeting after the database write succeeds.
      setSubmittedName(trimmedName);
    } catch (error) {
      setSubmitError(error.message);
    } finally {
      // finally runs whether the request succeeds or fails.
      setIsSubmitting(false);
    }
  };

  return (
    <div style={{ padding: "40px", fontFamily: "Arial" }}>
      {visitorCount !== null && <p>Visitor count: {visitorCount}</p>}
      {counterError && <p style={{ color: "crimson" }}>{counterError}</p>}

      {submittedName === "" ? (
        <form onSubmit={handleSubmit}>
          <h1>Welcome!</h1>

          <input
            type="text"
            placeholder="Enter your name"
            value={name}
            onChange={(e) => setName(e.target.value)}
            disabled={isSubmitting}
            style={{
              padding: "10px",
              fontSize: "16px",
              marginRight: "10px",
            }}
          />

          <button
            type="submit"
            disabled={isSubmitting}
            style={{
              padding: "10px 15px",
              fontSize: "16px",
              cursor: isSubmitting ? "not-allowed" : "pointer",
            }}
          >
            {isSubmitting ? "Saving..." : "Enter"}
          </button>

          {submitError && <p style={{ color: "crimson" }}>{submitError}</p>}
        </form>
      ) : (
        <div>
          <h1>Hello, {submittedName}.</h1>
          <p>This is my site.</p>
        </div>
      )}
    </div>
  );
}

export default App;
