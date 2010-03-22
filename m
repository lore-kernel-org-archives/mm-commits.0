From: akpm@linux-foundation.org
Subject: + maintainers-remove-obsolete-hpet-acpi-entry.patch added to -mm tree
Date: Mon, 22 Mar 2010 16:39:09 -0700
Message-ID: <201003222339.o2MNd9gQ001709@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56106 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755613Ab0CVXjU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Mar 2010 19:39:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, clemens@ladisch.de, venki@google.com


The patch titled
     MAINTAINERS: remove obsolete HPET ACPI entry
has been added to the -mm tree.  Its filename is
     maintainers-remove-obsolete-hpet-acpi-entry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
