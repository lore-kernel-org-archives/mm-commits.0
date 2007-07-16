From: akpm@linux-foundation.org
Subject: - use-menuconfig-objects-ii-module-menu.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:52:25 -0700
Message-ID: <200707162052.l6GKqPVh001546@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54967 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761619AbXGPVcF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:32:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@linux01.gwdg.de, jengelh@gmx.de, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Use menuconfig objects II - module menu
has been removed from the -mm tree.  Its filename was
     use-menuconfig-objects-ii-module-menu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Use menuconfig objects II - module menu
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Change menuconfig objects from "menu, config" into "menuconfig" so that the
user can disable the whole feature without entering its menu first.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN init/Kconfig~use-menuconfig-objects-ii-module-menu init/Kconfig
--- a/init/Kconfig~use-menuconfig-objects-ii-module-menu
+++ a/init/Kconfig
@@ -602,9 +602,7 @@ config BASE_SMALL
 	default 0 if BASE_FULL
 	default 1 if !BASE_FULL
 
-menu "Loadable module support"
-
-config MODULES
+menuconfig MODULES
 	bool "Enable loadable module support"
 	help
 	  Kernel modules are small pieces of compiled code which can
@@ -684,6 +682,5 @@ config STOP_MACHINE
 	depends on (SMP && MODULE_UNLOAD) || HOTPLUG_CPU
 	help
 	  Need stop_machine() primitive.
-endmenu
 
 source "block/Kconfig"
_

Patches currently in -mm which might be from jengelh@linux01.gwdg.de are

origin.patch
git-acpi.patch
git-kvm.patch
use-menuconfig-objects-pcmcia.patch
use-menuconfig-objects-ii-scsi.patch
use-menuconfig-objects-isdn-config_isdn.patch
use-menuconfig-objects-isdn-config_isdn_capi.patch
use-menuconfig-objects-isdn-config_capi_avm.patch
use-menuconfig-objects-isdn-config_capi_eicon.patch
use-menuconfig-objects-ii-md.patch
