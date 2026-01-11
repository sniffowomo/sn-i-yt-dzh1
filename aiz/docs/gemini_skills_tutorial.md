# Gemini CLI Skills Preview Feature

The Gemini CLI Skills preview feature allows you to extend the capabilities of the Gemini CLI by defining custom "skills" that the agent can invoke. These skills essentially act as pre-defined functions or tools that can automate complex or repetitive tasks, integrate with external systems, or encapsulate specific logic.

When you define a skill, you provide:
-   A **name**: How the skill is referred to.
-   A **description**: Explains what the skill does, helping the agent understand when to use it.
-   **Parameters** (optional): Any inputs the skill requires.
-   The **implementation**: The actual code or commands that the skill executes.

This empowers the Gemini agent to perform actions beyond its built-in knowledge, making it a more versatile and powerful assistant for software development and other tasks. The agent can "learn" new capabilities by being provided with these skill definitions.

## Concrete Example: "create_react_component" Skill

Let's imagine you frequently create React functional components with a specific file structure (e.g., a `.jsx` file and an accompanying `.module.css` file). You could define a skill to automate this.

**Skill Definition (Conceptual YAML/JSON or similar format):**

```yaml
skill:
  name: create_react_component
  description: Creates a new React functional component with a JSX file and an accompanying CSS module file.
  parameters:
    component_name:
      type: string
      description: The name of the React component (e.g., "MyButton").
    path:
      type: string
      description: The directory where the component files should be created (e.g., "src/components").
  implementation: |
    # This would be the script/command executed by the skill
    COMPONENT_NAME=$component_name
    COMPONENT_PATH=$path
    mkdir -p "$COMPONENT_PATH/$COMPONENT_NAME"

    cat <<EOF > "$COMPONENT_PATH/$COMPONENT_NAME/$COMPONENT_NAME.jsx"
    import React from 'react';
    import styles from './$COMPONENT_NAME.module.css';

    const $COMPONENT_NAME = () => {
      return (
        <div className={styles.container}>
          <h1>Hello from $COMPONENT_NAME!</h1>
        </div>
      );
    };

    export default $COMPONENT_NAME;
    EOF

    cat <<EOF > "$COMPONENT_PATH/$COMPONENT_NAME/$COMPONENT_NAME.module.css"
    .container {
      padding: 20px;
      border: 1px solid #ccc;
      border-radius: 8px;
      background-color: #f9f9f9;
    }
    EOF

    echo "React component '$COMPONENT_NAME' created at '$COMPONENT_PATH/$COMPONENT_NAME'"
```

**How the Agent Would Use It:**

If you, as the user, were to tell the Gemini agent:

"Please create a new React component called `UserProfile` in the `frontend/src/components` directory."

The Gemini agent, recognizing this task aligns with its `create_react_component` skill, would then (after potentially confirming with you) invoke this skill with `component_name='UserProfile'` and `path='frontend/src/components'`.

**Expected Outcome:**

The skill would execute the `implementation` script, resulting in the creation of:
-   `frontend/src/components/UserProfile/UserProfile.jsx`
-   `frontend/src/components/UserProfile/UserProfile.module.css`

This demonstrates how skills enable the Gemini CLI to understand and act upon high-level requests by mapping them to predefined, executable operations, greatly enhancing its utility for developers.
