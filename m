From: akpm@linux-foundation.org
Subject: + gitignore-add-allconfig.patch added to -mm tree
Date: Thu, 06 Feb 2014 13:23:04 -0800
Message-ID: <52f3fd38.DBETJ+vWK3M/XkFf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49137 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbaBFVXF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Feb 2014 16:23:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mmarek@suse.cz, bp@suse.de

Subject: + gitignore-add-allconfig.patch added to -mm tree
To: bp@suse.de,mmarek@suse.cz
From: akpm@linux-foundation.org
Date: Thu, 06 Feb 2014 13:23:04 -0800


The patch titled
     Subject: gitignore: add all.config
has been added to the -mm tree.  Its filename is
     gitignore-add-allconfig.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/gitignore-add-allconfig.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/gitignore-add-allconfig.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Borislav Petkov <bp@suse.de>
Subject: gitignore: add all.config

This is used by kbuild to load preset Kconfig options.  We need to ignore
it, otherwise git clean kills it.

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .gitignore |    3 +++
 1 file changed, 3 insertions(+)

diff -puN .gitignore~gitignore-add-allconfig .gitignore
--- a/.gitignore~gitignore-add-allconfig
+++ a/.gitignore
@@ -92,3 +92,6 @@ extra_certificates
 signing_key.priv
 signing_key.x509
 x509.genkey
+
+# Kconfig presets
+all.config
_

Patches currently in -mm which might be from bp@suse.de are

gitignore-add-allconfig.patch
linux-next.patch

