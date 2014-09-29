From: akpm@linux-foundation.org
Subject: [merged] maintainers-new-documentation-maintainer.patch removed
 from -mm tree
Date: Mon, 29 Sep 2014 13:22:38 -0700
Message-ID: <5429bf8e.0/+Xw75ViqYQYZ3U%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40289 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754275AbaI2UWi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Sep 2014 16:22:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@infradead.org, jkosina@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: new Documentation maintainer
has been removed from the -mm tree.  Its filename was
     maintainers-new-documentation-maintainer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: MAINTAINERS: new Documentation maintainer

Transfer Documentation maintainership to Jiri Kosina.  Thanks, Jiri.

I'll still be reviewing and working on documentation.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN MAINTAINERS~maintainers-new-documentation-maintainer MAINTAINERS
--- a/MAINTAINERS~maintainers-new-documentation-maintainer
+++ a/MAINTAINERS
@@ -3012,9 +3012,8 @@ S:	Supported
 F:	drivers/acpi/dock.c
 
 DOCUMENTATION
-M:	Randy Dunlap <rdunlap@infradead.org>
+M:	Jiri Kosina <jkosina@suse.cz>
 L:	linux-doc@vger.kernel.org
-T:	quilt http://www.infradead.org/~rdunlap/Doc/patches/
 S:	Maintained
 F:	Documentation/
 X:	Documentation/ABI/
_

Patches currently in -mm which might be from rdunlap@infradead.org are

mm-slab_common-move-kmem_cache-definition-to-internal-header-fix-2.patch
mm-slab_common-move-kmem_cache-definition-to-internal-header-fix-2-fix.patch
mm-slab_common-commonize-slab-merge-logic.patch
mm-slab_common-commonize-slab-merge-logic-fix.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix-2.patch
maintainers-linaro-mm-sig-is-moderated.patch
lib-remove-prio_heap.patch
lib-rename-test_module-to-test_lkm.patch
autofs-the-documentation-i-wanted-to-read.patch
linux-next.patch
kernel-add-support-for-kernel-restart-handler-call-chain.patch
power-restart-call-machine_restart-instead-of-arm_pm_restart.patch
arm64-support-restart-through-restart-handler-call-chain.patch
arm-support-restart-through-restart-handler-call-chain.patch
watchdog-moxart-register-restart-handler-with-kernel-restart-handler.patch
watchdog-alim7101-register-restart-handler-with-kernel-restart-handler.patch
watchdog-sunxi-register-restart-handler-with-kernel-restart-handler.patch
arm-arm64-unexport-restart-handlers.patch
watchdog-s3c2410-add-restart-handler.patch
clk-samsung-register-restart-handlers-for-s3c2412-and-s3c2443.patch
clk-rockchip-add-restart-handler.patch
debugging-keep-track-of-page-owners.patch

