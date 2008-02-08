From: akpm@linux-foundation.org
Subject: + documentation-patch-tags-one-more-time.patch added to -mm tree
Date: Fri, 08 Feb 2008 10:15:38 -0800
Message-ID: <200802081815.m18IFJuK005787@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51648 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758463AbYBHSP3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 13:15:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: corbet@lwn.net, penberg@cs.helsinki.fi


The patch titled
     Documentation/patch-tags, one more time
has been added to the -mm tree.  Its filename is
     documentation-patch-tags-one-more-time.patch

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
Subject: Documentation/patch-tags, one more time
From: Jonathan Corbet <corbet@lwn.net>

Add a document describing the various tags attached to patches.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Cc: "Pekka Enberg" <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/00-INDEX   |    2 
 Documentation/patch-tags |   76 +++++++++++++++++++++++++++++++++++++
 2 files changed, 78 insertions(+)

diff -puN Documentation/00-INDEX~documentation-patch-tags-one-more-time Documentation/00-INDEX
--- a/Documentation/00-INDEX~documentation-patch-tags-one-more-time
+++ a/Documentation/00-INDEX
@@ -289,6 +289,8 @@ parport.txt
 	- how to use the parallel-port driver.
 parport-lowlevel.txt
 	- description and usage of the low level parallel port functions.
+patch-tags
+	- description of the tags which can be added to patches
 pci-error-recovery.txt
 	- info on PCI error recovery.
 pci.txt
diff -puN /dev/null Documentation/patch-tags
--- /dev/null
+++ a/Documentation/patch-tags
@@ -0,0 +1,76 @@
+Patches headed for the mainline may contain a variety of tags documenting
+who played a hand in (or was at least aware of) their progress.  All of
+these tags have the form:
+
+	Something-done-by: Full name <email@address> [optional random stuff]
+
+These tags are:
+
+From: 	   	The original author of the patch.  This tag will ensure
+		that credit is properly given when somebody other than the
+		original author submits the patch.
+
+Signed-off-by:  A person adding a Signed-off-by tag is attesting that the
+		patch, to the best of his or her knowledge, can legally be
+		merged into the mainline and distributed under the terms of
+		the GNU General Public License, version 2.  See the
+		Developer's Certificate of Origin, found in
+		Documentation/SubmittingPatches, for the precise meaning of
+		Signed-off-by.  This tag assures upstream maintainers that
+		the provenance of the patch is known and allows the origin
+		of the patch to be reviewed should copyright questions
+		arise.
+
+Acked-by:	The person named (who should be an active developer in the
+		area addressed by the patch) is aware of the patch and has
+		no objection to its inclusion; it informs upstream
+		maintainers that a certain degree of consensus on the patch
+		as been achieved..  An Acked-by tag does not imply any
+		involvement in the development of the patch or that a
+		detailed review was done.
+
+Reviewed-by:	The patch has been reviewed and found acceptable according
+		to the Reviewer's Statement as found at the bottom of this
+		file.  A Reviewed-by tag is a statement of opinion that the
+		patch is an appropriate modification of the kernel without
+		any remaining serious technical issues.  Any interested
+		reviewer (who has done the work) can offer a Reviewed-by
+		tag for a patch.  This tag serves to give credit to
+		reviewers and to inform maintainers of the degree of review
+		which has been done on the patch.
+
+Cc:		The person named was given the opportunity to comment on
+		the patch.  This is the only tag which might be added
+		without an explicit action by the person it names.  This
+		tag documents that potentially interested parties have been
+		included in the discussion.
+
+Tested-by:	The patch has been successfully tested (in some
+		environment) by the person named.  This tag informs
+		maintainers that some testing has been performed, provides
+		a means to locate testers for future patches, and ensures
+		credit for the testers.
+
+
+----
+
+Reviewer's statement of oversight
+
+By offering my Reviewed-by: tag, I state that:
+
+ (a) I have carried out a technical review of this patch to evaluate its
+     appropriateness and readiness for inclusion into the mainline kernel.
+
+ (b) Any problems, concerns, or questions relating to the patch have been
+     communicated back to the submitter.  I am satisfied with the
+     submitter's response to my comments.
+
+ (c) While there may be things that could be improved with this submission,
+     I believe that it is, at this time, (1) a worthwhile modification to
+     the kernel, and (2) free of known issues which would argue against its
+     inclusion.
+
+ (d) While I have reviewed the patch and believe it to be sound, I do not
+     (unless explicitly stated elsewhere) make any warranties or guarantees
+     that it will achieve its stated purpose or function properly in any
+     given situation.
_

Patches currently in -mm which might be from corbet@lwn.net are

git-hrt.patch
revert-git-hrt.patch
documentation-patch-tags-one-more-time.patch
