From: akpm@linux-foundation.org
Subject: + parport-mailing-list-is-subscribers-only.patch added to -mm tree
Date: Mon, 14 May 2007 22:42:55 -0700
Message-ID: <200705150542.l4F5gsrK002498@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47209 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755836AbXEOFnd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 May 2007 01:43:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     parport: mailing list is subscribers-only
has been added to the -mm tree.  Its filename is
     parport-mailing-list-is-subscribers-only.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: parport: mailing list is subscribers-only
From: Randy Dunlap <randy.dunlap@oracle.com>

linux-parport is subscribers-only:

Your mail to 'Linux-parport' with the subject
    Re: [QUESTION] parallel console configuration
Is being held until the list moderator can review it for approval.
The reason it is being held:
    Post by non-member to a members-only list

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~parport-mailing-list-is-subscribers-only MAINTAINERS
--- a/MAINTAINERS~parport-mailing-list-is-subscribers-only
+++ a/MAINTAINERS
@@ -2717,13 +2717,13 @@ L:	i2c@lm-sensors.org
 S:	Maintained
 
 PARALLEL PORT SUPPORT
-L:	linux-parport@lists.infradead.org
+L:	linux-parport@lists.infradead.org (subscribers-only)
 S:	Orphan
 
 PARIDE DRIVERS FOR PARALLEL PORT IDE DEVICES
 P:	Tim Waugh
 M:	tim@cyberelk.net
-L:	linux-parport@lists.infradead.org
+L:	linux-parport@lists.infradead.org (subscribers-only)
 W:	http://www.torque.net/linux-pp.html
 S:	Maintained
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

romfs-printk-format-warnings.patch
add-pci_try_set_mwi.patch
git-unionfs.patch
git-ipwireless_cs.patch
parport-mailing-list-is-subscribers-only.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-doc-fix.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
add-kstrndup.patch
add-argv_split.patch
add-argv_split-fix.patch
split-usermodehelper-setup-from-execution.patch
add-common-orderly_poweroff.patch
add-common-orderly_poweroff-fix.patch
tidy-up-usermode-helper-waiting-a-bit.patch
profile-likely-unlikely-macros.patch
