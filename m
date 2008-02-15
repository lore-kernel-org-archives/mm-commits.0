From: akpm@linux-foundation.org
Subject: + remove-is_processor_present-prototype.patch added to -mm tree
Date: Fri, 15 Feb 2008 13:27:13 -0800
Message-ID: <200802152127.m1FLRDYw024796@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42916 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752026AbYBOV2i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 16:28:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gcosta@redhat.com, lenb@kernel.org


The patch titled
     acpi: remove is_processor_present prototype
has been added to the -mm tree.  Its filename is
     remove-is_processor_present-prototype.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

remove-is_processor_present-prototype.patch
git-kvm.patch
