From: akpm@linux-foundation.org
Subject: - m68knommu-remove-unused-config-symbol-config_disktel.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:36:22 -0700
Message-ID: <200710162036.l9GKaMOA015179@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45842 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935941AbXJPVgl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:36:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gerg@snapgear.com, gerg@uclinux.org, rpjday@mindspring.com, mm-commits@vger.kernel.org


The patch titled
     M68KNOMMU: remove unused config symbol CONFIG_DISKtel
has been removed from the -mm tree.  Its filename was
     m68knommu-remove-unused-config-symbol-config_disktel.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: M68KNOMMU: remove unused config symbol CONFIG_DISKtel
From: Greg Ungerer <gerg@snapgear.com>

Remove unused config symbol CONFIG_DISKtel.
Pointed out by Robert P. J. Day <rpjday@mindspring.com>.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-m68knommu/system.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN include/asm-m68knommu/system.h~m68knommu-remove-unused-config-symbol-config_disktel include/asm-m68knommu/system.h
--- a/include/asm-m68knommu/system.h~m68knommu-remove-unused-config-symbol-config_disktel
+++ a/include/asm-m68knommu/system.h
@@ -253,8 +253,7 @@ cmpxchg(volatile int *p, int old, int ne
         ");				\
 })
 #elif defined(CONFIG_NETtel) || defined(CONFIG_eLIA) || \
-      defined(CONFIG_DISKtel) || defined(CONFIG_SECUREEDGEMP3) || \
-      defined(CONFIG_CLEOPATRA)
+      defined(CONFIG_SECUREEDGEMP3) || defined(CONFIG_CLEOPATRA)
 #define HARD_RESET_NOW() ({		\
         asm("				\
 	movew #0x2700, %sr;		\
_

Patches currently in -mm which might be from gerg@snapgear.com are

origin.patch
printk-add-interfaces-for-external-access-to-the-log-buffer.patch
printk-add-interfaces-for-external-access-to-the-log-buffer-fix.patch
printk-add-interfaces-for-external-access-to-the-log-buffer-fix-2.patch
