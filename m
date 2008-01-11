From: akpm@linux-foundation.org
Subject: + reporting-bugs-cc-the-mailing-list-too.patch added to -mm tree
Date: Fri, 11 Jan 2008 15:39:34 -0800
Message-ID: <200801112339.m0BNdYrK003786@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48584 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761669AbYAKXjq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jan 2008 18:39:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bfields@citi.umich.edu, randy.dunlap@oracle.com


The patch titled
     REPORTING-BUGS: cc the mailing list too
has been added to the -mm tree.  Its filename is
     reporting-bugs-cc-the-mailing-list-too.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-nfs.patch
git-nfsd.patch
documentation-move-dnotifytxt-to-filesystems.patch
documentation-move-sharedsubtreestxt-to-filesystems.patch
documentation-create-new-scheduler-subdirectory.patch
reporting-bugs-cc-the-mailing-list-too.patch
use-struct-path-in-struct-svc_export.patch
use-struct-path-in-struct-svc_export-checkpatch-fixes.patch
reiser4.patch
