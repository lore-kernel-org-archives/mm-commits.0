From: akpm@linux-foundation.org
Subject: [merged] documentation-kernel-parameterstxt-remove-capabilitydisable.patch removed from -mm tree
Date: Fri, 21 Dec 2012 12:39:13 -0800
Message-ID: <20121221203913.C022882004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:39336 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab2LUUjO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Dec 2012 15:39:14 -0500
Received: by mail-gg0-f201.google.com with SMTP id o6so516726ggm.2
        for <mm-commits@vger.kernel.org>; Fri, 21 Dec 2012 12:39:14 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jwboyer@redhat.com, mszeredi@suse.cz, rob@landley.net, serge.hallyn@canonical.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation: kernel-parameters.txt remove capability.disable
has been removed from the -mm tree.  Its filename was
     documentation-kernel-parameterstxt-remove-capabilitydisable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
