Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D85D4F88A
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 23:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Quc61TSL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47FB5C433C9;
	Wed, 20 Dec 2023 23:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703113423;
	bh=vCvxtyVWJ54fW9CmCz8M65vCaEiWyxp8ow3ChLGOKPo=;
	h=Date:To:From:Subject:From;
	b=Quc61TSLbVqtJzJ9liaXWAwy5Q5qxfDBVNMH77QaqzNDSEYKacpKxgnR3C3Go5zaX
	 WNEVWJEJSzLIVq1q2I76NEna+AdzHDubHvnLsJFhkjWHhR7NhyHmp9FBiXY6JW430u
	 LULlWOpgIxYdXLj3otuXV1cKgmff96SZure2EI9g=
Date: Wed, 20 Dec 2023 15:03:42 -0800
To: mm-commits@vger.kernel.org,nicolas@fjasle.eu,nathan@kernel.org,masahiroy@kernel.org,klondike@klondike.es,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] usr-kconfig-fix-typos-of-its.patch removed from -mm tree
Message-Id: <20231220230343.47FB5C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: usr/Kconfig: fix typos of "its"
has been removed from the -mm tree.  Its filename was
     usr-kconfig-fix-typos-of-its.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: usr/Kconfig: fix typos of "its"
Date: Sat, 9 Dec 2023 21:34:29 -0800

Use "Its" or "its" for possessive instead of "it's" (contraction
for "it is").

Link: https://lkml.kernel.org/r/20231210053429.23146-1-rdunlap@infradead.org
Fixes: db2aa7fd15e8 ("initramfs: allow again choice of the embedded initram compression algorithm")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Nicolas Schier <nicolas@fjasle.eu>
Acked-by: "Francisco Blas Izquierdo Riera (klondike)" <klondike@klondike.es>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 usr/Kconfig |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/usr/Kconfig~usr-kconfig-fix-typos-of-its
+++ a/usr/Kconfig
@@ -185,9 +185,9 @@ config INITRAMFS_COMPRESSION_LZO
 	bool "LZO"
 	depends on RD_LZO
 	help
-	  It's compression ratio is the second poorest amongst the choices. The
-	  kernel size is about 10% bigger than gzip. Despite that, it's
-	  decompression speed is the second fastest and it's compression speed
+	  Its compression ratio is the second poorest amongst the choices. The
+	  kernel size is about 10% bigger than gzip. Despite that, its
+	  decompression speed is the second fastest and its compression speed
 	  is quite fast too.
 
 	  If you choose this, keep in mind that you may need to install the lzop
_

Patches currently in -mm which might be from rdunlap@infradead.org are

stacktrace-fix-kernel-doc-typo.patch
nilfs2-cpfile-fix-some-kernel-doc-warnings.patch

