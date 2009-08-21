// @HEADER
// ***********************************************************************
// 
//          Tpetra: Templated Linear Algebra Services Package
//                 Copyright (2008) Sandia Corporation
// 
// Under terms of Contract DE-AC04-94AL85000, there is a non-exclusive
// license for use of this work by or on behalf of the U.S. Government.
// 
// This library is free software; you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as
// published by the Free Software Foundation; either version 2.1 of the
// License, or (at your option) any later version.
//  
// This library is distributed in the hope that it will be useful, but
// WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// Lesser General Public License for more details.
//  
// You should have received a copy of the GNU Lesser General Public
// License along with this library; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
// USA
// Questions? Contact Michael A. Heroux (maherou@sandia.gov) 
// 
// ***********************************************************************
// @HEADER

#ifndef TPETRA_IMPORTEXPORTDATA_HPP
#define TPETRA_IMPORTEXPORTDATA_HPP

#include <Teuchos_RCP.hpp>
#include <Teuchos_OrdinalTraits.hpp>
#include <Teuchos_Array.hpp>
#include <Teuchos_ArrayRCP.hpp>
#include <Teuchos_Object.hpp>

namespace Tpetra {

#ifndef DOXYGEN_SHOULD_SKIP_THIS
  // forward declaration of Import,Export, needed to prevent circular inclusions
  template<class LocalOrdinal, class GlobalOrdinal, class Node> class Import;
  template<class LocalOrdinal, class GlobalOrdinal, class Node> class Export;
#endif

  template<class LocalOrdinal, class GlobalOrdinal, class Node>
  class ImportExportData : public Teuchos::Object {
    friend class Import<LocalOrdinal,GlobalOrdinal,Node>;
    friend class Export<LocalOrdinal,GlobalOrdinal,Node>;
  public:
    ImportExportData(const Map<LocalOrdinal,GlobalOrdinal,Node> & source, const Map<LocalOrdinal,GlobalOrdinal,Node> & target);
    ~ImportExportData();

  protected:
    // OT vectors
    Teuchos::Array<LocalOrdinal> permuteToLIDs_;
    Teuchos::Array<LocalOrdinal> permuteFromLIDs_;
    Teuchos::Array<LocalOrdinal> remoteLIDs_;
    Teuchos::Array<GlobalOrdinal> exportGIDs_;
    // These are ArrayRCP because in the construction of an Import object, they are allocated and returned by a call to 
    Teuchos::ArrayRCP<LocalOrdinal> exportLIDs_;
    Teuchos::ArrayRCP<int> exportImageIDs_;

    size_t numSameIDs_;

    // Maps
    const Map<LocalOrdinal,GlobalOrdinal,Node> source_;
    const Map<LocalOrdinal,GlobalOrdinal,Node> target_;

    // Comm, Distributor
    Teuchos::RCP<const Teuchos::Comm<int> > comm_;
    Distributor distributor_;

  private:
    //! Copy constructor (declared but not defined, do not use)
    ImportExportData(const ImportExportData<LocalOrdinal,GlobalOrdinal,Node> &rhs);
    //! Assignment operator (declared but not defined, do not use)
    ImportExportData<LocalOrdinal,GlobalOrdinal,Node> & operator = (ImportExportData<LocalOrdinal,GlobalOrdinal,Node> const& rhs);
  }; // class ImportExportData


  template <class LocalOrdinal, class GlobalOrdinal, class Node>
  ImportExportData<LocalOrdinal,GlobalOrdinal,Node>::ImportExportData(const Map<LocalOrdinal,GlobalOrdinal,Node> & source, const Map<LocalOrdinal,GlobalOrdinal,Node> & target)
  : numSameIDs_(0)
  , source_(source)
  , target_(target)
  , comm_(source.getComm())
  , distributor_(comm_)
  {}

  template <class LocalOrdinal, class GlobalOrdinal, class Node>
  ImportExportData<LocalOrdinal,GlobalOrdinal,Node>::~ImportExportData() 
  {}

} // namespace Tpetra

#endif // TPETRA_IMPORTEXPORTDATA_HPP
