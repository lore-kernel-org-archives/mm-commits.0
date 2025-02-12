Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388E81D5143
	for <mm-commits@vger.kernel.org>; Wed, 12 Feb 2025 21:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739396389; cv=none; b=tPo3pPbn0EL4seq0w2uXsyqZmPOROfmxVyyf3iy99AfvVCccwtQQ3V4GNnizdh1juSfTHUDmeBu+tTuviak8YFWu5kXzt2ZKQ/co1nzzaqnnLNVxQNp6QD1JJosP8yjNdMawBiGnvMzeDRhgMcmxWzpWwYdLKVa/C0YO6yAfom4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739396389; c=relaxed/simple;
	bh=orKU5t0IY7soE/2B6hDeA6LaZgmTSUWgiYo4xobLWn4=;
	h=Date:To:From:Subject:Message-Id; b=PwUBQVGl5lt73koYklMyDzk9GTTOPY8HAjzoUE5PH+6ttSTCK0/muALXabmkahAkr8mWPTC7qZfMSBcprlDTJtqIgnc9w81DWph0/KtqKzDIvzdj53TyhtedASw8MWCvlcYob1xcp+dvJ3qdqNZeFXlCw10ZDPJY8/R9yHJO4gM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ViKJCeoH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ViKJCeoH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B642C4CEDF;
	Wed, 12 Feb 2025 21:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739396388;
	bh=orKU5t0IY7soE/2B6hDeA6LaZgmTSUWgiYo4xobLWn4=;
	h=Date:To:From:Subject:From;
	b=ViKJCeoHw4sIvQGSKKYghf0fy2idZK0XSW+z3EYz/ZLd3hBFVg3tyomb2V7HlsTwW
	 AQ/F03nhT6k0iQxMRKEFuzZapFbRb24h6ZVd5IL6btXZ+RiQZ4gKYZfs0If5/zPofT
	 DyvDsCtM647bPOCMrpj3E36iRSn/SBis63rX5wXQ=
Date: Wed, 12 Feb 2025 13:39:47 -0800
To: mm-commits@vger.kernel.org,ndesaulniers@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-update-nicks-contact-info.patch added to mm-hotfixes-unstable branch
Message-Id: <20250212213948.9B642C4CEDF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: update Nick's contact info
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-update-nicks-contact-info.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-update-nicks-contact-info.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
@@ -5663,7 +5663,7 @@ F:	.clang-format
 
 CLANG/LLVM BUILD SUPPORT
 M:	Nathan Chancellor <nathan@kernel.org>
-R:	Nick Desaulniers <ndesaulniers@google.com>
+R:	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>
 R:	Bill Wendling <morbo@google.com>
 R:	Justin Stitt <justinstitt@google.com>
 L:	llvm@lists.linux.dev
_

Patches currently in -mm which might be from ndesaulniers@google.com are

maintainers-update-nicks-contact-info.patch

