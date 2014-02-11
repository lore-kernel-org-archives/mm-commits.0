From: akpm@linux-foundation.org
Subject: [merged] gitignore-add-allconfig.patch removed from -mm tree
Date: Tue, 11 Feb 2014 11:23:40 -0800
Message-ID: <52fa78bc.DRV4+3eY+cA2vXyE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40898 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260AbaBKTXk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Feb 2014 14:23:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mmarek@suse.cz, bp@suse.de

Subject: [merged] gitignore-add-allconfig.patch removed from -mm tree
To: bp@suse.de,mmarek@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 11 Feb 2014 11:23:40 -0800


The patch titled
     Subject: gitignore: add all.config
has been removed from the -mm tree.  Its filename was
     gitignore-add-allconfig.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

