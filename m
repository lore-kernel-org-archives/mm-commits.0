From: akpm@linux-foundation.org
Subject: - remove-the-deprecated-kmem_cache_t-typedef-from-slabh.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:48:53 -0700
Message-ID: <200707162048.l6GKmrqv001108@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37268 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753369AbXGPUtF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 16:49:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, clameter@sgi.com, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     Remove the deprecated "kmem_cache_t" typedef from slab.h.
has been removed from the -mm tree.  Its filename was
     remove-the-deprecated-kmem_cache_t-typedef-from-slabh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 2 deletions(-)

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
git-alsa.patch
git-powerpc.patch
git-dvb.patch
git-kbuild.patch
git-kvm.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
remove-dead-references-to-module_parm-macro.patch
git-watchdog.patch
i386-uaccessh-replace-hard-coded-constant-with-appropriate-macro-from-kernelh.patch
i386-ioapic-remove-old-irq-balancing-debug-cruft.patch
i386-deactivate-the-test-for-the-dead-config_debug_page_type.patch
mm-make-needlessly-global-hugetlb_no_page-static.patch
