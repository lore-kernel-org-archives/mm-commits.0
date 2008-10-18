From: akpm@linux-foundation.org
Subject: - fbdev-epson-s1d1-framebuffer-maintainer.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:19:45 -0700
Message-ID: <200810182319.m9INJjJ2029546@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51751 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751898AbYJRXUV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:20:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kristoffer.ericson@gmail.com, Kristoffer.Ericson@gmail.com, krzysztof.h1@poczta.fm, varenet@parisc-linux.org, mm-commits@vger.kernel.org


The patch titled
     fbdev: Epson S1D1 framebuffer maintainer
has been removed from the -mm tree.  Its filename was
     fbdev-epson-s1d1-framebuffer-maintainer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1629,6 +1629,11 @@ P:	Christopher Hoover
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

origin.patch

