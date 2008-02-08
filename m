From: akpm@linux-foundation.org
Subject: - reporting-bugs-cc-the-mailing-list-too.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:02:32 -0800
Message-ID: <200802080802.m1882DUE014019@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36521 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761780AbYBHITq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:19:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bfields@citi.umich.edu, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     REPORTING-BUGS: cc the mailing list too
has been removed from the -mm tree.  Its filename was
     reporting-bugs-cc-the-mailing-list-too.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: REPORTING-BUGS: cc the mailing list too
From: "J. Bruce Fields" <bfields@citi.umich.edu>

People should also cc relevant mailing lists when reporting bugs.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 REPORTING-BUGS |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN REPORTING-BUGS~reporting-bugs-cc-the-mailing-list-too REPORTING-BUGS
--- a/REPORTING-BUGS~reporting-bugs-cc-the-mailing-list-too
+++ a/REPORTING-BUGS
@@ -10,11 +10,12 @@ bug report. This explains what you shoul
 to make it useful to the recipient.
 
       Send the output to the maintainer of the kernel area that seems to
-be involved with the problem. Don't worry too much about getting the
-wrong person. If you are unsure send it to the person responsible for the
-code relevant to what you were doing. If it occurs repeatably try and
-describe how to recreate it. That is worth even more than the oops itself.
-The list of maintainers is in the MAINTAINERS file in this directory.
+be involved with the problem, and cc the relevant mailing list. Don't
+worry too much about getting the wrong person. If you are unsure send it
+to the person responsible for the code relevant to what you were doing.
+If it occurs repeatably try and describe how to recreate it. That is
+worth even more than the oops itself.  The list of maintainers and
+mailing lists is in the MAINTAINERS file in this directory.
 
       If it is a security bug, please copy the Security Contact listed
 in the MAINTAINERS file.  They can help coordinate bugfix and disclosure.
_

Patches currently in -mm which might be from bfields@citi.umich.edu are

origin.patch
use-struct-path-in-struct-svc_export.patch
use-struct-path-in-struct-svc_export-checkpatch-fixes.patch
reiser4.patch
