From: akpm@linux-foundation.org
Subject: [to-be-updated] maintainers-remove-obsolete-hpet-acpi-entry.patch removed from -mm tree
Date: Sun, 28 Mar 2010 13:34:35 -0400
Message-ID: <201003282035.o2SKZdXP003498@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50524 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755190Ab0C1Uft (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 28 Mar 2010 16:35:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, clemens@ladisch.de, venki@google.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: remove obsolete HPET ACPI entry
has been removed from the -mm tree.  Its filename was
     maintainers-remove-obsolete-hpet-acpi-entry.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: remove obsolete HPET ACPI entry
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Bob Picco is no longer at HP.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Venkatesh Pallipadi <venki@google.com>
Cc: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    5 -----
 1 file changed, 5 deletions(-)

diff -puN MAINTAINERS~maintainers-remove-obsolete-hpet-acpi-entry MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-obsolete-hpet-acpi-entry
+++ a/MAINTAINERS
@@ -2680,11 +2680,6 @@ S:	Maintained
 F:	arch/x86/kernel/hpet.c
 F:	arch/x86/include/asm/hpet.h
 
-HPET:	ACPI
-M:	Bob Picco <bob.picco@hp.com>
-S:	Maintained
-F:	drivers/char/hpet.c
