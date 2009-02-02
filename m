From: akpm@linux-foundation.org
Subject: + maintainers-add-the-missing-linux-alpha-port-mailling-list.patch added to -mm tree
Date: Mon, 02 Feb 2009 12:48:30 -0800
Message-ID: <200902022048.n12KmUZo012286@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56517 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754005AbZBBUtF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Feb 2009 15:49:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: crquan@gmail.com, ink@jurassic.park.msu.ru, rth@twiddle.net


The patch titled
     MAINTAINERS: add the missing linux alpha port mailling list
has been added to the -mm tree.  Its filename is
     maintainers-add-the-missing-linux-alpha-port-mailling-list.patch

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
Subject: MAINTAINERS: add the missing linux alpha port mailling list
From: Cheng Renquan <crquan@gmail.com>

Signed-off-by: Cheng Renquan <crquan@gmail.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff -puN MAINTAINERS~maintainers-add-the-missing-linux-alpha-port-mailling-list MAINTAINERS
--- a/MAINTAINERS~maintainers-add-the-missing-linux-alpha-port-mailling-list
+++ a/MAINTAINERS
@@ -357,6 +357,7 @@ S:	Odd Fixes for 2.4; Maintained for 2.6
 P:	Ivan Kokshaysky
 M:	ink@jurassic.park.msu.ru
 S:	Maintained for 2.4; PCI support for 2.6.
+L:	linux-alpha@vger.kernel.org
 
 AMD GEODE CS5536 USB DEVICE CONTROLLER DRIVER
 P:	Thomas Dahlmann
_

Patches currently in -mm which might be from crquan@gmail.com are

linux-next.patch
do_pipe-drop-its-last-user-in-arch-alpha.patch
do_pipe-drop-its-last-user-in-arch-alpha-checkpatch-fixes.patch
maintainers-add-the-missing-linux-alpha-port-mailling-list.patch

