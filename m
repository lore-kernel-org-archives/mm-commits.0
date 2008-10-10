From: akpm@linux-foundation.org
Subject: + fbdev-epson-s1d1-framebuffer-maintainer.patch added to -mm tree
Date: Fri, 10 Oct 2008 14:17:14 -0700
Message-ID: <200810102117.m9ALHEBA003277@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57332 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757936AbYJJVSG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Oct 2008 17:18:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kristoffer.ericson@gmail.com, Kristoffer.Ericson@gmail.com, krzysztof.h1@poczta.fm, varenet@parisc-linux.org


The patch titled
     fbdev: Epson S1D1 framebuffer maintainer
has been added to the -mm tree.  Its filename is
     fbdev-epson-s1d1-framebuffer-maintainer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev: Epson S1D1 framebuffer maintainer
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>

I'm stepping up as maintainer for the Epson S1D13XXXFB driver since I have
2 platforms currently using it.

Signed-off-by: Kristoffer Ericson <Kristoffer.Ericson@gmail.com>
Acked-by: Thibaut Varene <varenet@parisc-linux.org>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN MAINTAINERS~fbdev-epson-s1d1-framebuffer-maintainer MAINTAINERS
--- a/MAINTAINERS~fbdev-epson-s1d1-framebuffer-maintainer
+++ a/MAINTAINERS
@@ -1636,6 +1636,11 @@ P:	Christopher Hoover
 M:	ch@murgatroid.com, ch@hpl.hp.com
 S:	Maintained
 
+EPSON S1D13XXX FRAMEBUFFER DRIVER
+P:	Kristoffer Ericson
+M:	kristoffer.ericson@gmail.com
+S:	Maintained
+
 ETHEREXPRESS-16 NETWORK DRIVER
 P:	Philip Blundell
 M:	philb@gnu.org
_

Patches currently in -mm which might be from kristoffer.ericson@gmail.com are

git-arm.patch
fbdev-allow-more-chip-revisions-in-epson-s1d13-video-driver.patch
fbdev-allow-more-chip-revisions-in-epson-s1d13-video-driver-cleanups.patch
fbdev-epson-s1d1-framebuffer-maintainer.patch

