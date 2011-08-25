From: akpm@linux-foundation.org
Subject: + maintainers-add-new-entry-for-ideapad-laptop.patch added to -mm tree
Date: Thu, 25 Aug 2011 15:00:33 -0700
Message-ID: <201108252200.p7PM0XBK013957@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43145 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755573Ab1HYWBK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Aug 2011 18:01:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ike.pan@canonical.com, mjg@redhat.com


The patch titled
     MAINTAINERS: add new entry for ideapad-laptop
has been added to the -mm tree.  Its filename is
     maintainers-add-new-entry-for-ideapad-laptop.patch

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
Subject: MAINTAINERS: add new entry for ideapad-laptop
From: Ike Panhc <ike.pan@canonical.com>

Signed-off-by: Ike Panhc <ike.pan@canonical.com>
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN MAINTAINERS~maintainers-add-new-entry-for-ideapad-laptop MAINTAINERS
--- a/MAINTAINERS~maintainers-add-new-entry-for-ideapad-laptop
+++ a/MAINTAINERS
@@ -3202,6 +3202,13 @@ F:	Documentation/ide/
 F:	drivers/ide/
 F:	include/linux/ide.h
 
+IDEAPAD LAPTOP EXTRAS DRIVER
+M:	Ike Panhc <ike.pan@canonical.com>
+L:	platform-driver-x86@vger.kernel.org
+W:	http://launchpad.net/ideapad-laptop
+S:	Maintained
+F:	drivers/platform/x86/ideapad-laptop.c
+
 IDE/ATAPI DRIVERS
 M:	Borislav Petkov <petkovbb@gmail.com>
 L:	linux-ide@vger.kernel.org
_

Patches currently in -mm which might be from ike.pan@canonical.com are

maintainers-add-new-entry-for-ideapad-laptop.patch

