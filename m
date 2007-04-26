From: akpm@linux-foundation.org
Subject: - drivers-acpi-kconfig-formulation-fixpatch.patch removed from -mm tree
Date: Wed, 25 Apr 2007 23:59:11 -0700
Message-ID: <200704260659.l3Q6xBKF023121@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56408 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933174AbXDZG7N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Apr 2007 02:59:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bbpetkov@yahoo.de, mm-commits@vger.kernel.org


The patch titled
     drivers/acpi/Kconfig formulation fix
has been removed from the -mm tree.  Its filename was
     drivers-acpi-kconfig-formulation-fixpatch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/acpi/Kconfig formulation fix
From: Borislav Petkov <bbpetkov@yahoo.de>

This one fixes an incorrect formulation in a Kconfig description.

Signed-off-by: <bbpetkov@yahoo.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/acpi/Kconfig~drivers-acpi-kconfig-formulation-fixpatch drivers/acpi/Kconfig
--- a/drivers/acpi/Kconfig~drivers-acpi-kconfig-formulation-fixpatch
+++ a/drivers/acpi/Kconfig
@@ -85,8 +85,8 @@ config ACPI_PROCFS
 	depends on ACPI
 	default y
 	---help---
-	  Procfs interface for ACPI is made optional for back-compatible.
-	  As the same functions are duplicated in sysfs interface
+	  The Procfs interface for ACPI is made optional for backward compatibility.
+	  As the same functions are duplicated in the sysfs interface
 	  and this proc interface will be removed some time later,
 	  it's marked as deprecated.
 	  ( /proc/acpi/debug_layer && debug_level are deprecated by
_

Patches currently in -mm which might be from bbpetkov@yahoo.de are

git-acpi.patch
git-net.patch
kernel-doc-handle-arrays-with-arithmetic-expressions-as.patch
generate-main-index-page-when-building-htmldocs.patch
alphabetically-sorted-entries-in.patch
kill-warnings-when-building-mandocs.patch
