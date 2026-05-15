import React, { useState } from "react";

function App() {
  const [name, setName] = useState("");
  const [submittedName, setSubmittedName] = useState("");

  const handleSubmit = (e) => {
    e.preventDefault();
    setSubmittedName(name);
  };

  return (
    <div style={{ padding: "40px", fontFamily: "Arial" }}>
      {submittedName === "" ? (
        <form onSubmit={handleSubmit}>
          <h1>Welcome!</h1>

          <input
            type="text"
            placeholder="Enter your name"
            value={name}
            onChange={(e) => setName(e.target.value)}
            style={{
              padding: "10px",
              fontSize: "16px",
              marginRight: "10px",
            }}
          />

          <button
            type="submit"
            style={{
              padding: "10px 15px",
              fontSize: "16px",
              cursor: "pointer",
            }}
          >
            Enter
          </button>
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