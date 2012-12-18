From: akpm@linux-foundation.org
Subject: + documentation-kernel-parameterstxt-remove-capabilitydisable.patch added to -mm tree
Date: Tue, 18 Dec 2012 13:50:04 -0800
Message-ID: <20121218215005.29EAB200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f201.google.com ([209.85.215.201]:38430 "EHLO
	mail-ea0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569Ab2LRVuI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 16:50:08 -0500
Received: by mail-ea0-f201.google.com with SMTP id b14so66933eaa.0
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 13:50:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jwboyer@redhat.com, mszeredi@suse.cz, rob@landley.net, serge.hallyn@canonical.com


The patch titled
     Subject: Documentation: kernel-parameters.txt remove capability.disable
has been added to the -mm tree.  Its filename is
     documentation-kernel-parameterstxt-remove-capabilitydisable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Josh Boyer <jwboyer@redhat.com>
Subject: Documentation: kernel-parameters.txt remove capability.disable

Remove the documentation for capability.disable.  The code supporting this
parameter was removed with:

	commit 5915eb53861c5776cfec33ca4fcc1fd20d66dd27
	Author: Miklos Szeredi <mszeredi@suse.cz>
	Date:   Thu Jul 3 20:56:05 2008 +0200

    	security: remove dummy module

Signed-off-by: Josh Boyer <jwboyer@redhat.com>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Rob Landley <rob@landley.net>
Cc: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    6 ------
 1 file changed, 6 deletions(-)

diff -puN Documentation/kernel-parameters.txt~documentation-kernel-parameterstxt-remove-capabilitydisable Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~documentation-kernel-parameterstxt-remove-capabilitydisable
+++ a/Documentation/kernel-parameters.txt
@@ -446,12 +446,6 @@ bytes respectively. Such letter suffixes
 			possible to determine what the correct size should be.
 			This option provides an override for these situations.
 
-	capability.disable=
-			[SECURITY] Disable capabilities.  This would normally
-			be used only if an alternative security model is to be
-			configured.  Potentially dangerous and should only be
-			used if you are entirely sure of the consequences.
