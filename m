Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 021F11FCFCB
	for <mm-commits@vger.kernel.org>; Thu,  6 Feb 2025 07:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738827961; cv=none; b=LbluYAyhMQ2E11WkJKlxDAshgHMK/aqQ6Ttfu0BBbxi6PaHaoN8HbuaYeW9Tok+hz55TOnGyIrrPmpZKfz8L0QhzSzmUfMh4Mk9yT/ytAtT18RkTnp3/KbSKX7yqY2DRI/WaKmIbGdikJDdq7TeY/iunC4tBUCC6KoKbg7cARsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738827961; c=relaxed/simple;
	bh=NIMK+S+5n6EfJmFtXhEPqKS7eNuVbFO7N6bh5LPFukg=;
	h=Date:To:From:Subject:Message-Id; b=n71hzaitree+05kL5NpnXDvoSL4q0TWSIFZozRednOciqsHXvqhpd4Rh1Ov03JAvLsZWboOOlV6Ufz40raZ5HkmbffcmNo+XVKSg3qWdgwybuFrGxui3ipb6W9RCVWtOHl10l/yLmWGZ5o7bKeqY6IzURI99Q1i5QRyIOw4rKGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wx2VW+Z8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wx2VW+Z8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99963C4CEDD;
	Thu,  6 Feb 2025 07:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738827960;
	bh=NIMK+S+5n6EfJmFtXhEPqKS7eNuVbFO7N6bh5LPFukg=;
	h=Date:To:From:Subject:From;
	b=wx2VW+Z826vNQWDvFO3HS1qSvg6hJ1YsvopAwPnZc5UuPR3fEibYr9JmjEHTezR9m
	 LMWgThh8JqEvrR7heZixMySwCG9ClD34Mxk0DRrjynyowHLjfwVpx0kBNtes8PUM5D
	 IoqeMsc2O0MKyuyMba49wn8g8fE92ZZT0upaTN5g=
Date: Wed, 05 Feb 2025 23:46:00 -0800
To: mm-commits@vger.kernel.org,jeff.johnson@oss.qualcomm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-add-entries-for-jeff-johnson.patch added to mm-hotfixes-unstable branch
Message-Id: <20250206074600.99963C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: .mailmap: add entries for Jeff Johnson
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-add-entries-for-jeff-johnson.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-add-entries-for-jeff-johnson.patch

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
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: .mailmap: add entries for Jeff Johnson
Date: Wed, 05 Feb 2025 12:01:00 -0800

Map past iterations of my e-mail addresses to the current one.

Link: https://lkml.kernel.org/r/20250205-jjohnson-mailmap-v1-1-269cb7b1710d@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    2 ++
 1 file changed, 2 insertions(+)

--- a/.mailmap~mailmap-add-entries-for-jeff-johnson
+++ a/.mailmap
@@ -315,6 +315,8 @@ Jayachandran C <c.jayachandran@gmail.com
 Jean Tourrilhes <jt@hpl.hp.com>
 Jeevan Shriram <quic_jshriram@quicinc.com> <jshriram@codeaurora.org>
 Jeff Garzik <jgarzik@pretzel.yyz.us>
+Jeff Johnson <jeff.johnson@oss.qualcomm.com> <jjohnson@codeaurora.org>
+Jeff Johnson <jeff.johnson@oss.qualcomm.com> <quic_jjohnson@quicinc.com>
 Jeff Layton <jlayton@kernel.org> <jlayton@poochiereds.net>
 Jeff Layton <jlayton@kernel.org> <jlayton@primarydata.com>
 Jeff Layton <jlayton@kernel.org> <jlayton@redhat.com>
_

Patches currently in -mm which might be from jeff.johnson@oss.qualcomm.com are

mailmap-add-entries-for-jeff-johnson.patch

