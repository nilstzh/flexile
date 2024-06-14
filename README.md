_This repo follows Rails-like structure, but only provides rough examples for corresponding migrations/models/controllers._

### 1. Business Logic Questions

To ensure the feature is built correctly, further clarification on the following business logic questions is needed:

__1. What is the definition of "project"? What properties it might have and what operations it must support?__

This is the fundamental question for the feature. Because we will introduce a new table in the database, it is important to understand how do we want "projects" to function, to properly design data-layer.

__2. What is expected to be built around "projects" in the future?__

Understanding as much as possible what are the foreseeable related features is also necessary for designing a data-layer. The more we know what do we want to build tomorrow the easier it is to avoid major pains in the future.

__3. Should there be one contractor per project or can there be multiple?__

This is important to define contractor/project relations. If "projects" are somewhat atomic and require 1 contractor (e.g. "Landing page design") then there will be one-to-many relationship. If "project" is something big (e.g. "Build online marketplace") and need multiple contractors than there will be many-to-many relationship.

__4. How do we handle rates? Do we allow change of rate?__

Since there monthly rates already I would check how they are handled to use the same approach where applicable (e.g. in terms of currency or data types used in the DB).

__5. Do we need to track changes in rates over time? Should there be a history log for rates and project changes?__

__6. What are project statuses to be implemented? How do they need to function?__

__7. Do projects have deadlines? What are deadlines-related behaviors?__

__8. Should there be a single invoice per project/contractor or can there be multiple? (in case we go with one-to-many otherwise not applicable)__

__9. Will there be "milestones"? What is the behavior?__

__10. Do we want any automatic behaviors? (e.g. to change status of the "project" when invoice is approved)?__

__11. Any notifications to be sent (e.g. to the contractors when projects are created/updated)?__

__12. How adding projects and project-based rates should change Analytics?__

__13. How projects and project-based rates will interact with Equity?__

__14. Who can create, edit, and delete projects? Are there different levels of access for different user roles?__

_All the questions above are general. There would be more with the access to the existing codebase._

### 2. Migrations

To allow project-based rates we need
- create `projects` table to store projects,
- create `projects_contractors` table providing many-to-many relationship between projects and contractors (even if many-to-many isn't required right now I would still go with this design to allow easily switch to it in the future, as it is much simpler to limit this approach to one-to-many by changing association to `has_one :through` than to change one-to-many with direct table relation down the road),
- add necessary columns to store the rates.

To see implementation example check 3 migrations in `migrations/` folder:
- `create_contractors.rb` - I assume that `contractors` table already exists but including migration anyway because it is referenced in another migration.
- `create_projects.rb` - Includes just few fields essential to handle projects.
- `create_projects_contractors.rb` - Provides many-to-many relationships between `projects` and `contractors`.

Notes:
- in the given example `projects_contractors.rate` is an integer as it is usually easier to handle than floats, but in real life it would depend on the existing project setup and consistent approach must be followed,
- same goes for `projects_contractors.currency`.

### 2. Backend

##### 2.1 Models

Changes required:
- update the `Contractor` model and create the `Project` model to establish associations,
- create the `ProjectsContractors` model,
- make changes to `Contractors` model necessary to allow contractors with project-based rates (e.g. make `contractors.hourly_rate` and `contractors.avg_hours` nullable if they aren't)

Examples can be found in the `models/` folder.

##### 2.2 Controllers

Changes required:
- create `ProjectsController` with CRUD actions,
- update `create` and `update` actions of `ContractorsController` to allow contractors with project-based rates (e.g. allow `project_id` param),
- implement creating `ProjectContractors` records in corresponding `ProjectsController` and `ContractorsController` actions (create/update).

Examples can be found in the `controllers/` folder.

##### 2.3 Update routes

- add CRUD routes for `ProjectsController`

##### 2.4 Services to handle business logic

Create/update services to handle required business logic.

##### 2.5 Tests

- Add tests for the new models, controllers, and views.
- Ensure validations and business logic are tested.

##### 2.6 Documentation

- Update API documentation to include new endpoints and parameters.
- Provide internal documentation for the new business logic and data relationships.

### 3. Front-End Changes

On frontend side following changes are necessary:

1. Update `People` views:

  - Index view:

    - Display contractors with project-based rates (questions to designer: how? separate tab? same table? links to projects?)

![people_index](/images/people_index.png)

---

  - Create view:

    - Add select input "Rate type" (hourly/project-based), based on selection, dynamically show relevant fields.
    - If "project-based" type chosen add fields "Project(s)" (potentially can be a multiselect).
    - Add "Create new" button for "Project(s)" field (like the existing button for "Role").

![people_create](/images/people_create.png)

---

2. Create new "Projects" views (and navigation item in the navigation section):

  - Index View: List all projects with options to view, edit, and delete.
  - Create/Update View: Form for creating and updating projects.

---

3. Update Analytics view if required

4. Update Equity view if required

### 4. Design System Changes

Design system changes might include updates to existing UI components or the creation of new components to support project rate management.

- Review existing components to see if they can be reused or need modifications.
- Design new components if necessary (e.g. icon for navigation section), ensuring they are consistent with the overall design system.
- Update style guides and documentation accordingly.
