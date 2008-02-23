From: akpm@linux-foundation.org
Subject: - remove-is_processor_present-prototype.patch removed from -mm tree
Date: Sat, 23 Feb 2008 12:21:22 -0800
Message-ID: <200802232021.m1NKLMEU013329@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:53727 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760152AbYBWUWP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 15:22:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gcosta@redhat.com, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     acpi: remove is_processor_present prototype
has been removed from the -mm tree.  Its filename was
     remove-is_processor_present-prototype.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: remove is_processor_present prototype
From: Glauber Costa <gcosta@redhat.com>

The function itself is defined just below, so this prototype is not really
useful.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/processor_core.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/acpi/processor_core.c~remove-is_processor_present-prototype drivers/acpi/processor_core.c
--- a/drivers/acpi/processor_core.c~remove-is_processor_present-prototype
+++ a/drivers/acpi/processor_core.c
@@ -826,8 +826,6 @@ static int acpi_processor_remove(struct 
  * 	Acpi processor hotplug support 				       	    *
  ****************************************************************************/
 
-static int is_processor_present(acpi_handle handle);
-
 static int is_processor_present(acpi_handle handle)
 {
 	acpi_status status;
_

Patches currently in -mm which might be from gcosta@redhat.com are

origin.patch
acpi-use-acpi_debug_print-instead-of-printk.patch
git-kvm.patch
fix-typo-in-tick-broadcastc.patch
