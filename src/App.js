import React, { useEffect, useState } from "react";

function App() {
  const [name, setName] = useState("");
  const [submittedName, setSubmittedName] = useState("");
  const [visitorCount, setVisitorCount] = useState(null);
  const [counterError, setCounterError] = useState("");
  const [submitError, setSubmitError] = useState("");
  const [isSubmitting, setIsSubmitting] = useState(false);

  useEffect(() => {
    const updateVisitorCount = async () => {
      try {
        const response = await fetch("/api/count");
        if (!response.ok) {
          throw new Error("Unable to update visitor counter.");
        }

        const data = await response.json();
        setVisitorCount(data.counter);
      } catch (error) {
        setCounterError(error.message);
      }
    };

    updateVisitorCount();
  }, []);

  const handleSubmit = async (e) => {
    e.preventDefault();
    const trimmedName = name.trim();
    if (!trimmedName) {
      setSubmitError("Please enter your name.");
      return;
    }

    setIsSubmitting(true);
    setSubmitError("");

    try {
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

      setSubmittedName(trimmedName);
    } catch (error) {
      setSubmitError(error.message);
    } finally {
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
