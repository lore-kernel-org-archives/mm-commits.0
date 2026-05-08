Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78375225413
	for <mm-commits@vger.kernel.org>; Fri,  8 May 2026 19:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778269453; cv=none; b=gk5VhY/QXBgM7NutubzbiRBN2VPRSLcr0YCkBg8VRZZcHi977iniRiJtB/QLqcBA61bjvnG/jS+8xUzZPlZoWXS+Zl17m8VsIpJ7EqwRwuYEkfX/k+WJ2n2c3yM7UkbiJ4uf0DTdQS87IaQXMLkiAUTIjA6+zap0CbKPuOfUcJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778269453; c=relaxed/simple;
	bh=S9ArJQZxrwIlmFuFwrixCPEA1JeipAIIlQtJ/l7reKs=;
	h=Date:To:From:Subject:Message-Id; b=o6sl7nUCZpss7mPXUc2LLSdGctvW7tyNlGXV5egzDRL7LsNyM5BK1N+Eod69oRVujhT5PCSPXWd/IqO7H1QeAPTg/OCUfrtCwVoWGkK9rvTZOB7ZcKS6TUAatzRX0jFLAjJjHvkhEmTJ5RsNzO8QzB/M4Hi1TusoiEzBnsfxS/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aZJpHsxi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aZJpHsxi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12524C2BCB0;
	Fri,  8 May 2026 19:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778269453;
	bh=S9ArJQZxrwIlmFuFwrixCPEA1JeipAIIlQtJ/l7reKs=;
	h=Date:To:From:Subject:From;
	b=aZJpHsxiJuZ7RtFJUY857Q0X1qXjKDLQ6RzytFenCmEq6lfNFj4dXusDQXHuziW0X
	 e8zwvBxSfkRzZvzAoz+H9z/qh/JZNFdXFYS4LalIw1Cws1kPYabAGGSvNbPwvzL/A+
	 7VbJ4lcuSs6Mv/twGTsjWLq2RTz05+CnrWK7BO/A=
Date: Fri, 08 May 2026 12:44:12 -0700
To: mm-commits@vger.kernel.org,lukas.bulwahn@gmail.com,dwaipayanray1@gmail.com,joe@perches.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-credits-remove-inactive-checkpatch-reviewers.patch added to mm-nonmm-unstable branch
Message-Id: <20260508194413.12524C2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS/CREDITS: Remove inactive checkpatch reviewers
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     maintainers-credits-remove-inactive-checkpatch-reviewers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-credits-remove-inactive-checkpatch-reviewers.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS/CREDITS: Remove inactive checkpatch reviewers
Date: Thu, 07 May 2026 10:41:46 -0700

Dwaipayan Ray and Lukas Bulwahn have not commented on checkpatch in
several years.

Lukas is still active on MAINTAINERS.
Create an entry in CREDITS for Dwaipayan.

Link: https://lore.kernel.org/64f057d1d7f247583eb616337b89b3ff7bcc627f.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 CREDITS     |    4 ++++
 MAINTAINERS |    2 --
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/CREDITS~maintainers-credits-remove-inactive-checkpatch-reviewers
+++ a/CREDITS
@@ -3368,6 +3368,10 @@ N: Anil Ravindranath
 E: anil_ravindranath@pmc-sierra.com
 D: PMC-Sierra MaxRAID driver
 
+N: Dwaipayan Ray
+E: dwaipayanray1@gmail.com
+D: checkpatch improvements
+
 N: Eric S. Raymond
 E: esr@thyrsus.com
 W: http://www.tuxedo.org/~esr/
--- a/MAINTAINERS~maintainers-credits-remove-inactive-checkpatch-reviewers
+++ a/MAINTAINERS
@@ -5962,8 +5962,6 @@ F:	drivers/input/keyboard/charlieplex_ke
 CHECKPATCH
 M:	Andy Whitcroft <apw@canonical.com>
 M:	Joe Perches <joe@perches.com>
-R:	Dwaipayan Ray <dwaipayanray1@gmail.com>
-R:	Lukas Bulwahn <lukas.bulwahn@gmail.com>
 S:	Maintained
 F:	scripts/checkpatch.pl
 
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-add-check-for-function-pointer-arrays-in-declarations.patch
maintainers-credits-remove-inactive-checkpatch-reviewers.patch

