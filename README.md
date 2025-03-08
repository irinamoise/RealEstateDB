# Real Estate Agency Database Project

This project involves the design and implementation of a relational database for a real estate agency in Bucharest. The database will manage information about addresses, property owners, properties, apartments, houses, property details, clients, agents, tenants, buyers, rental agreements, sale-purchase contracts, and property viewings.

---

## **Purpose**
- **Efficient Storage and Management**: Store and manage information about properties and clients efficiently.
- **Quick Access to Data**: Facilitate quick access to data about properties available for sale or rent.
- **Activity Monitoring**: Monitor the activity of real estate agents and property viewings.

---

## **Functionality Rules**
1. **Properties and Addresses**:
   - Each property must be associated with a unique address.
2. **Property Owners**:
   - Each owner can have one or more properties.
3. **Clients**:
   - Clients can be tenants, buyers, or individuals viewing properties.
4. **Viewings**:
   - Each viewing must be associated with an agent, a client, and a property.

---

## **Database Structure**
The database will include the following entities:
- **Addresses**: Unique locations of properties.
- **Owners**: Individuals or entities owning properties.
- **Properties**: General information about properties (apartments, houses, etc.).
- **Clients**: Individuals interested in renting, buying, or viewing properties.
- **Agents**: Real estate agents managing properties and clients.
- **Rental Agreements**: Contracts for renting properties.
- **Sale-Purchase Contracts**: Contracts for buying properties.
- **Viewings**: Records of property viewings by clients.

