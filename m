From: akpm@linux-foundation.org
Subject: + krealloc-fix-kerneldoc-comments.patch added to -mm tree
Date: Tue, 08 May 2007 16:26:19 -0700
Message-ID: <200705082326.l48NQJ17004676@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42992 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967480AbXEHX1C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 19:27:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: penberg@cs.helsinki.fi, clameter@sgi.com, randy.dunlap@oracle.com


The patch titled
     krealloc: fix kerneldoc comments
has been added to the -mm tree.  Its filename is
     krealloc-fix-kerneldoc-comments.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: krealloc: fix kerneldoc comments
From: Pekka J Enberg <penberg@cs.helsinki.fi>

No "blank" (or "*") line is allowed between the function name and lines for
it parameter(s).

Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    1 -
 mm/slub.c |    1 -
 2 files changed, 2 deletions(-)

diff -puN mm/slab.c~krealloc-fix-kerneldoc-comments mm/slab.c
--- a/mm/slab.c~krealloc-fix-kerneldoc-comments
+++ a/mm/slab.c
@@ -3742,7 +3742,6 @@ EXPORT_SYMBOL(__kmalloc);
 
 /**
  * krealloc - reallocate memory. The contents will remain unchanged.
- *
  * @p: object to reallocate memory for.
  * @new_size: how many bytes of memory are required.
  * @flags: the type of memory to allocate.
diff -puN mm/slub.c~krealloc-fix-kerneldoc-comments mm/slub.c
--- a/mm/slub.c~krealloc-fix-kerneldoc-comments
+++ a/mm/slub.c
@@ -2286,7 +2286,6 @@ EXPORT_SYMBOL(kmem_cache_shrink);
 
 /**
  * krealloc - reallocate memory. The contents will remain unchanged.
- *
  * @p: object to reallocate memory for.
  * @new_size: how many bytes of memory are required.
  * @flags: the type of memory to allocate.
_

Patches currently in -mm which might be from penberg@cs.helsinki.fi are

origin.patch
increase-slab-redzone-to-64bits.patch
module-use-krealloc.patch
krealloc-fix-kerneldoc-comments.patch
unionfs-fix-slab-abuses-with-krealloc.patch
swsusp-use-reasonable-default-for-hibernation_mode.patch
slab-use-cpu_lock_.patch
separate-freezer-from-pm-code-rev-2.patch
introduce-freezer-flags-rev-2.patch
revoke-special-mmap-handling.patch
revoke-special-mmap-handling-vs-fault-vs-invalidate.patch
revoke-core-code.patch
revoke-core-code-misc-fixes.patch
revoke-core-code-fix-shared-mapping-revoke.patch
revoke-core-code-move-magic.patch
revoke-core-code-fs-revokec-cleanups-and-bugfix-for-64bit-systems.patch
revoke-core-code-revoke-no-revoke-for-nommu.patch
revoke-core-code-fix-shared-mapping-revoke-revoke-only-revoke-mappings-for-the-given-inode.patch
revoke-core-code-break-cow-for-private-mappings.patch
revoke-core-code-generic_file_revoke-stub-for-nommu.patch
revoke-core-code-break-cow-fixes.patch
revoke-core-code-mapping-revocation.patch
revoke-core-code-only-fput-unused-files.patch
revoke-core-code-rename-to-can_revoke_filevma.patch
revoke-core-code-change-revoke_table-to-fileset-and-revoke_details.patch
revoke-core-code-do_revoke-error-handling.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
slab-leaks3-default-y.patch
