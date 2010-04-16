From: akpm@linux-foundation.org
Subject: + documentation-submittingdrivers-resources.patch added to -mm tree
Date: Fri, 16 Apr 2010 12:13:27 -0700
Message-ID: <201004161913.o3GJDRNs022353@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53611 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758458Ab0DPTOI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Apr 2010 15:14:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: x0066660@ti.com, randy.dunlap@oracle.com


The patch titled
     Documentation: SubmittingDrivers: Resources
has been added to the -mm tree.  Its filename is
     documentation-submittingdrivers-resources.patch

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
Subject: Documentation: SubmittingDrivers: Resources
From: "Arce, Abraham" <x0066660@ti.com>

- Add additional location (Git) for the kernel master tree
- Add reference to Git Project

Signed-off-by: Abraham Arce <x0066660@ti.com>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/SubmittingDrivers |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN Documentation/SubmittingDrivers~documentation-submittingdrivers-resources Documentation/SubmittingDrivers
--- a/Documentation/SubmittingDrivers~documentation-submittingdrivers-resources
+++ a/Documentation/SubmittingDrivers
@@ -130,6 +130,8 @@ Linux kernel master tree:
 	ftp.??.kernel.org:/pub/linux/kernel/...
 	?? == your country code, such as "us", "uk", "fr", etc.
 
+	http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git
+
 Linux kernel mailing list:
 	linux-kernel@vger.kernel.org
 	[mail majordomo@vger.kernel.org to subscribe]
@@ -160,3 +162,7 @@ How to NOT write kernel driver by Arjan 
 
 Kernel Janitor:
 	http://janitor.kernelnewbies.org/
+
+GIT, Fast Version Control System:
+	http://git-scm.com/
+
_

Patches currently in -mm which might be from x0066660@ti.com are

documentation-submittingdrivers-resources.patch

