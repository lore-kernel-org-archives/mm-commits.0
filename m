From: akpm@linux-foundation.org
Subject: + remove-the-deprecated-kmem_cache_t-typedef-from-slabh.patch added to -mm tree
Date: Mon, 21 May 2007 13:58:28 -0700
Message-ID: <200705212058.l4LKwSDJ019883@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60106 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755124AbXEUVA7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 17:00:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, clameter@sgi.com, penberg@cs.helsinki.fi


The patch titled
     Remove the deprecated "kmem_cache_t" typedef from slab.h.
has been added to the -mm tree.  Its filename is
     remove-the-deprecated-kmem_cache_t-typedef-from-slabh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Remove the deprecated "kmem_cache_t" typedef from slab.h.
From: "Robert P. J. Day" <rpjday@mindspring.com>

Given that there is no remaining usage of the deprecated kmem_cache_t
typedef anywhere in the tree, remove that typedef.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |    2 --
 1 files changed, 2 deletions(-)

diff -puN include/linux/slab.h~remove-the-deprecated-kmem_cache_t-typedef-from-slabh include/linux/slab.h
--- a/include/linux/slab.h~remove-the-deprecated-kmem_cache_t-typedef-from-slabh
+++ a/include/linux/slab.h
@@ -14,8 +14,6 @@
 #include <linux/gfp.h>
 #include <linux/types.h>
 
-typedef struct kmem_cache kmem_cache_t __deprecated;
-
 /*
  * Flags to pass to kmem_cache_create().
  * The ones marked DEBUG are only valid if CONFIG_SLAB_DEBUG is set.
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
remove-unused-header-file-arch-arm-mach-s3c2410-basth.patch
git-ieee1394.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
documentation-fix-the-explanation-of-kconfig-files.patch
remove-the-deprecated-kmem_cache_t-typedef-from-slabh.patch
remove-unnecessary-includes-of-spinlockh-under-include-linux.patch
