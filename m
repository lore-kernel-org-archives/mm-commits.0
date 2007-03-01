From: akpm@linux-foundation.org
Subject: + parport-is-an-orphan.patch added to -mm tree
Date: Thu, 01 Mar 2007 00:01:28 -0800
Message-ID: <200703010801.l2181Sg6008103@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33211 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932569AbXCAIBg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 03:01:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net


The patch titled
     parport is an orphan
has been added to the -mm tree.  Its filename is
     parport-is-an-orphan.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: parport is an orphan
From: David Brownell <david-b@pacbell.net>

The writing on the wall seem to be that the parport stack is orphaned,
rather than maintained by four folk ...  and having a webpage that says the
latest patches are based on a 2.5 kernel.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff -puN MAINTAINERS~parport-is-an-orphan MAINTAINERS
--- a/MAINTAINERS~parport-is-an-orphan
+++ a/MAINTAINERS
@@ -2639,16 +2639,8 @@ L:	i2c@lm-sensors.org
 S:	Maintained
 
 PARALLEL PORT SUPPORT
-P:	Phil Blundell
-M:	philb@gnu.org
-P:	Tim Waugh
-M:	tim@cyberelk.net
-P:	David Campbell
-P:	Andrea Arcangeli
-M:	andrea@suse.de
 L:	linux-parport@lists.infradead.org
-W:	http://people.redhat.com/twaugh/parport/
-S:	Maintained
+S:	Orphan
 
 PARIDE DRIVERS FOR PARALLEL PORT IDE DEVICES
 P:	Tim Waugh
_

Patches currently in -mm which might be from david-b@pacbell.net are

rtc_cmos-oops-fix.patch
parport-is-an-orphan.patch
git-avr32.patch
git-md-accel.patch
8250-make-probing-for-txen-bug-a-config-option.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
