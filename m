Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 426D51AF0CB
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 06:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739860863; cv=none; b=dVikUKpIsMyzbUBmG35EU4vH1wZ1OtcDGh9wLD0Uma9KdngJ1hEv1Q6VDUaofqyzoil9xiwQOF2TAoHAaviiuqTOXfKxIzNqEuSs0NcPjmDkE2jb9XZFQsV3g3nJVvSh5pHVcxtDOC/4cqYVdxQotQ3XEWj+1BNrRjQMx35Zm08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739860863; c=relaxed/simple;
	bh=QiG/UEXBO8vn67s0Q2Tg4LckTDwFRXMAtEhFFGQf3qU=;
	h=Date:To:From:Subject:Message-Id; b=JhCBWiPHvPginevlKS0OIEIrbamxX0HBWIr4XrdONeuh/wD6igZ3lTQaOEEi8a7pNPA14L+V7wev0VWyGzl/24/hTiRtCf5+bKuJmOhN5yq+VB2ZCVvtIZ5vTph4f9TzzG5rT9dTdHzhO3yAL7Eqsl5ll6MZ1BIijNNvaEV6WuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VdLjoSFT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VdLjoSFT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5ADBC4CEE2;
	Tue, 18 Feb 2025 06:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739860863;
	bh=QiG/UEXBO8vn67s0Q2Tg4LckTDwFRXMAtEhFFGQf3qU=;
	h=Date:To:From:Subject:From;
	b=VdLjoSFT9/utM65W2D09c0rguLQd9q2hEo6LAFFZMow4bnplkYX804EPTPmnpy53c
	 TxEh9vvDuo3FPGCO0j/WTjmgGRbdX1Of5Lwlb5qx1pJx+bFXjGBqrwFqX/cxe78CgO
	 iSzwPe7uiBtn/redjdgJhTffJm5ZktSGkLKWtYGs=
Date: Mon, 17 Feb 2025 22:41:02 -0800
To: mm-commits@vger.kernel.org,ndesaulniers@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-update-nicks-contact-info.patch removed from -mm tree
Message-Id: <20250218064102.E5ADBC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: update Nick's contact info
has been removed from the -mm tree.  Its filename was
     maintainers-update-nicks-contact-info.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nick Desaulniers <ndesaulniers@google.com>
Subject: MAINTAINERS: update Nick's contact info
Date: Wed, 12 Feb 2025 09:35:20 -0800

Updated .mailmap, but forgot these other places.

Link: https://lkml.kernel.org/r/20250212173523.3979840-1-ndesaulniers@google.com
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/process/embargoed-hardware-issues.rst                    |    2 +-
 Documentation/translations/sp_SP/process/embargoed-hardware-issues.rst |    2 +-
 MAINTAINERS                                                            |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/Documentation/process/embargoed-hardware-issues.rst~maintainers-update-nicks-contact-info
+++ a/Documentation/process/embargoed-hardware-issues.rst
@@ -308,7 +308,7 @@ an involved disclosed party. The current
 
   Google	Kees Cook <keescook@chromium.org>
 
-  LLVM		Nick Desaulniers <ndesaulniers@google.com>
+  LLVM		Nick Desaulniers <nick.desaulniers+lkml@gmail.com>
   ============= ========================================================
 
 If you want your organization to be added to the ambassadors list, please
--- a/Documentation/translations/sp_SP/process/embargoed-hardware-issues.rst~maintainers-update-nicks-contact-info
+++ a/Documentation/translations/sp_SP/process/embargoed-hardware-issues.rst
@@ -287,7 +287,7 @@ revelada involucrada. La lista de embaja
 
   Google	Kees Cook <keescook@chromium.org>
 
-  LLVM		Nick Desaulniers <ndesaulniers@google.com>
+  LLVM		Nick Desaulniers <nick.desaulniers+lkml@gmail.com>
   ============= ========================================================
 
 Si quiere que su organización se añada a la lista de embajadores, por
--- a/MAINTAINERS~maintainers-update-nicks-contact-info
+++ a/MAINTAINERS
@@ -5655,7 +5655,7 @@ F:	.clang-format
 
 CLANG/LLVM BUILD SUPPORT
 M:	Nathan Chancellor <nathan@kernel.org>
-R:	Nick Desaulniers <ndesaulniers@google.com>
+R:	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>
 R:	Bill Wendling <morbo@google.com>
 R:	Justin Stitt <justinstitt@google.com>
 L:	llvm@lists.linux.dev
_

Patches currently in -mm which might be from ndesaulniers@google.com are


