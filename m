From: akpm@linux-foundation.org
Subject: + acpica-fix-acpi_ex_release_mutex-comment.patch added to -mm tree
Date: Fri, 08 Jan 2010 16:35:23 -0800
Message-ID: <201001090035.o090ZN8x023856@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42926 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751189Ab0AIAha (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jan 2010 19:37:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bzolnier@gmail.com, error27@gmail.com, lenb@kernel.org, ming.m.lin@intel.com, robert.moore@intel.com


The patch titled
     acpica: fix acpi_ex_release_mutex() comment
has been added to the -mm tree.  Its filename is
     acpica-fix-acpi_ex_release_mutex-comment.patch

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
Subject: acpica: fix acpi_ex_release_mutex() comment
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

trivial, leftover from my NULL pointer dereference patch which got
'superseded' by commit fbc3be2

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Lin Ming <ming.m.lin@intel.com>
Cc: Bob Moore <robert.moore@intel.com>
Cc: Dan Carpenter <error27@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/acpica/exmutex.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/acpi/acpica/exmutex.c~acpica-fix-acpi_ex_release_mutex-comment drivers/acpi/acpica/exmutex.c
--- a/drivers/acpi/acpica/exmutex.c~acpica-fix-acpi_ex_release_mutex-comment
+++ a/drivers/acpi/acpica/exmutex.c
@@ -375,8 +375,7 @@ acpi_ex_release_mutex(union acpi_operand
 		return_ACPI_STATUS(AE_AML_MUTEX_NOT_ACQUIRED);
 	}
 
-	/* Must have a valid thread ID */
