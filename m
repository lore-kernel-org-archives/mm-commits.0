From: akpm@linux-foundation.org
Subject: - documentation-patch-tags-one-more-time.patch removed from -mm tree
Date: Sat, 12 Apr 2008 19:40:25 -0700
Message-ID: <200804130240.m3D2eP1T032504@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54089 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755542AbYDMCkc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 Apr 2008 22:40:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: corbet@lwn.net, penberg@cs.helsinki.fi, pj@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Documentation/patch-tags, one more time
has been removed from the -mm tree.  Its filename was
     documentation-patch-tags-one-more-time.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Documentation/patch-tags, one more time
From: Jonathan Corbet <corbet@lwn.net>

Add a document describing the various tags attached to patches.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Cc: "Pekka Enberg" <penberg@cs.helsinki.fi>
Reviewed-by: Paul Jackson <pj@sgi.com>
Acked-by: Paul Jackson <pj@sgi.com>
Tested-by: Paul Jackson <pj@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/SubmittingPatches |   54 ++++++++++++++++++++++++++++--
 1 file changed, 51 insertions(+), 3 deletions(-)

diff -puN Documentation/SubmittingPatches~documentation-patch-tags-one-more-time Documentation/SubmittingPatches
--- a/Documentation/SubmittingPatches~documentation-patch-tags-one-more-time
+++ a/Documentation/SubmittingPatches
@@ -328,7 +328,7 @@ now, but you can do this to mark interna
 point out some special detail about the sign-off. 
 
 
-13) When to use Acked-by:
+13) When to use Acked-by: and Cc:
 
 The Signed-off-by: tag indicates that the signer was involved in the
 development of the patch, or that he/she was in the patch's delivery path.
@@ -349,11 +349,59 @@ Acked-by: does not necessarily indicate 
 For example, if a patch affects multiple subsystems and has an Acked-by: from
 one subsystem maintainer then this usually indicates acknowledgement of just
 the part which affects that maintainer's code.  Judgement should be used here.
- When in doubt people should refer to the original discussion in the mailing
+When in doubt people should refer to the original discussion in the mailing
 list archives.
 
+If a person has had the opportunity to comment on a patch, but has not
+provided such comments, you may optionally add a "Cc:" tag to the patch.
+This is the only tag which might be added without an explicit action by the
+person it names.  This tag documents that potentially interested parties
+have been included in the discussion
 
-14) The canonical patch format
+
+14) Using Test-by: and Reviewed-by:
+
+A Tested-by: tag indicates that the patch has been successfully tested (in
+some environment) by the person named.  This tag informs maintainers that
+some testing has been performed, provides a means to locate testers for
+future patches, and ensures credit for the testers.
+
+Reviewed-by:, instead, indicates that the patch has been reviewed and found
+acceptable according to the Reviewer's Statement:
+
+	Reviewer's statement of oversight
+
+	By offering my Reviewed-by: tag, I state that:
+
+ 	 (a) I have carried out a technical review of this patch to
+	     evaluate its appropriateness and readiness for inclusion into
+	     the mainline kernel.
+
+	 (b) Any problems, concerns, or questions relating to the patch
+	     have been communicated back to the submitter.  I am satisfied
+	     with the submitter's response to my comments.
+
+	 (c) While there may be things that could be improved with this
+	     submission, I believe that it is, at this time, (1) a
+	     worthwhile modification to the kernel, and (2) free of known
+	     issues which would argue against its inclusion.
+
+	 (d) While I have reviewed the patch and believe it to be sound, I
+	     do not (unless explicitly stated elsewhere) make any
+	     warranties or guarantees that it will achieve its stated
+	     purpose or function properly in any given situation.
+
+A Reviewed-by tag is a statement of opinion that the patch is an
+appropriate modification of the kernel without any remaining serious
+technical issues.  Any interested reviewer (who has done the work) can
+offer a Reviewed-by tag for a patch.  This tag serves to give credit to
+reviewers and to inform maintainers of the degree of review which has been
+done on the patch.  Reviewed-by: tags, when supplied by reviewers known to
+understand the subject area and to perform thorough reviews, will normally
+increase the liklihood of your patch getting into the kernel.
+
+
+15) The canonical patch format
 
 The canonical patch subject line is:
 
_

Patches currently in -mm which might be from corbet@lwn.net are

git-dvb.patch

