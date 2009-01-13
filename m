From: akpm@linux-foundation.org
Subject: + maintainers-add-entry-for-freezer.patch added to -mm tree
Date: Tue, 13 Jan 2009 13:50:54 -0800
Message-ID: <200901132150.n0DLosXJ031447@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34689 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752621AbZAMVvc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Jan 2009 16:51:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pavel@suse.cz, rjw@sisk.pl


The patch titled
     MAINTAINERS: add entry for freezer
has been added to the -mm tree.  Its filename is
     maintainers-add-entry-for-freezer.patch

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
Subject: MAINTAINERS: add entry for freezer
From: Pavel Machek <pavel@suse.cz>

Now that people are using freezer for non-suspend/hibernation stuff, it
should have separate maintainers entry so that it is easier to find.

Signed-off-by: Pavel Machek <pavel@suse.cz>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN MAINTAINERS~maintainers-add-entry-for-freezer MAINTAINERS
--- a/MAINTAINERS~maintainers-add-entry-for-freezer
+++ a/MAINTAINERS
@@ -1821,6 +1821,14 @@ M:	hch@infradead.org
 W:	ftp://ftp.openlinux.org/pub/people/hch/vxfs
 S:	Maintained
 
+FREEZER
+P:	Pavel Machek
+M:	pavel@suse.cz
+P:	Rafael J. Wysocki
+M:	rjw@sisk.pl
+L:	linux-pm@lists.linux-foundation.org
+S:	Supported
+
 FTRACE
 P:	Steven Rostedt
 M:	rostedt@goodmis.org
_

Patches currently in -mm which might be from pavel@suse.cz are

lis3lv02d-merge-with-leds-hp-disk.patch
maintainers-add-entry-for-freezer.patch
linux-next.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code-checkpatch-fixes.patch

