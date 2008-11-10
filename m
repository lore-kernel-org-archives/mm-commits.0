From: akpm@linux-foundation.org
Subject: + ssb-hide-empty-sub-menu.patch added to -mm tree
Date: Mon, 10 Nov 2008 15:34:27 -0800
Message-ID: <200811102334.mAANYSHx017061@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35591 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752540AbYKJXfV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Nov 2008 18:35:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, johannes@sipsolutions.net, mb@bu3sch.de


The patch titled
     ssb: hide empty sub menu
has been added to the -mm tree.  Its filename is
     ssb-hide-empty-sub-menu.patch

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
Subject: ssb: hide empty sub menu
From: Mike Frysinger <vapier@gentoo.org>

If the target system cannot support SSB, then don't show the menu option as
it'll simply be an empty submenu.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Michael Buesch <mb@bu3sch.de>
Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ssb/Kconfig |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/ssb/Kconfig~ssb-hide-empty-sub-menu drivers/ssb/Kconfig
--- a/drivers/ssb/Kconfig~ssb-hide-empty-sub-menu
+++ a/drivers/ssb/Kconfig
@@ -1,10 +1,11 @@
-menu "Sonics Silicon Backplane"
