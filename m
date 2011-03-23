From: akpm@linux-foundation.org
Subject: [merged] maintainers-remove-unnecessary-linux-kernel-vgerkernelorg-entries.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:39:47 -0700
Message-ID: <201103232043.p2NKhNId028859@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47514 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933454Ab1CWUn4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:43:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, harryxiyou@gmail.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: remove unnecessary linux-kernel@vger.kernel.org entries
has been removed from the -mm tree.  Its filename was
     maintainers-remove-unnecessary-linux-kernel-vgerkernelorg-entries.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: remove unnecessary linux-kernel@vger.kernel.org entries
From: Joe Perches <joe@perches.com>

CC'ing lkml is the default and doesn't need separate entries.

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Harry Wei <harryxiyou@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    5 -----
 1 file changed, 5 deletions(-)

diff -puN MAINTAINERS~maintainers-remove-unnecessary-linux-kernel-vgerkernelorg-entries MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-unnecessary-linux-kernel-vgerkernelorg-entries
+++ a/MAINTAINERS
@@ -2824,7 +2824,6 @@ F:	include/linux/gigaset_dev.h
 
 GPIO SUBSYSTEM
 M:	Grant Likely <grant.likely@secretlab.ca>
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 T:	git git://git.secretlab.ca/git/linux-2.6.git
 F:	Documentation/gpio/gpio.txt
@@ -2847,7 +2846,6 @@ F:	drivers/platform/x86/hdaps.c
 HWPOISON MEMORY FAILURE HANDLING
 M:	Andi Kleen <andi@firstfloor.org>
 L:	linux-mm@kvack.org
-L:	linux-kernel@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-mce-2.6.git hwpoison
 S:	Maintained
 F:	mm/memory-failure.c
@@ -4725,7 +4723,6 @@ F:	drivers/i2c/busses/i2c-pasemi.c
 
 PADATA PARALLEL EXECUTION MECHANISM
 M:	Steffen Klassert <steffen.klassert@secunet.com>
-L:	linux-kernel@vger.kernel.org
 L:	linux-crypto@vger.kernel.org
 S:	Maintained
 F:	kernel/padata.c
@@ -4875,7 +4872,6 @@ F:	include/crypto/pcrypt.h
 PER-CPU MEMORY ALLOCATOR
 M:	Tejun Heo <tj@kernel.org>
 M:	Christoph Lameter <cl@linux-foundation.org>
-L:	linux-kernel@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git
 S:	Maintained
 F:	include/linux/percpu*.h
@@ -6923,7 +6919,6 @@ F:	sound/soc/codecs/wm*
 
 WORKQUEUE
 M:	Tejun Heo <tj@kernel.org>
-L:	linux-kernel@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git
 S:	Maintained
 F:	include/linux/workqueue.h
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch

