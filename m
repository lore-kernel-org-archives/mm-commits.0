Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC8C02745E
	for <mm-commits@vger.kernel.org>; Wed, 15 Apr 2026 05:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776232086; cv=none; b=C80T1reiOF1dP1gM9XaNXmfNveA4c+hBHhlen9tW+w72D2M7TekX/TtSKyvwar26jyZyTMEtjji1aY54RCbdy2hjma7bX4zX02/RL6b58IIo+NB8L68QWVPw+0MSGXiAoS8QGc/E9PE5P2eqnPTr1lSHgPlsVdk6gbMm+BxoESk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776232086; c=relaxed/simple;
	bh=Z4Cey5ZaM0RWtE0G4N9qullRgQ2VURnY+9JQyOmMJpE=;
	h=Date:To:From:Subject:Message-Id; b=Yal8J1m3sJHWkQWuAoGN68jofiutBV1rO0G5LiGm5AWQSbCxevk9F0hqrqr5IjqtnpXqZ6guV0rLsMKKsNFdCIkoZfDjaQXzVgE1LX+BbHAi1lGhkdpSb3N9t4K3CD/L+TlHDlr0PbU7AKgz4rswHGsNOt7VjNhVwNxPCn0YyOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=08eboDl0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="08eboDl0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D373FC19424;
	Wed, 15 Apr 2026 05:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776232086;
	bh=Z4Cey5ZaM0RWtE0G4N9qullRgQ2VURnY+9JQyOmMJpE=;
	h=Date:To:From:Subject:From;
	b=08eboDl0ziVFxsm6X0XUz8Aseppc89X8cFaGsvUSPCH0ki3LIN2zQL7tTpsTS/27n
	 cn9RZOVA5Aiq6jSCr6EYGqg1RzcE8L/wQzDmYeC+0r+tokHt+NExkgqpGouFW6luiS
	 kUPgTZ8rcBuC0E1xAFlp48jcKKiJzl0yxwb8iBno=
Date: Tue, 14 Apr 2026 22:48:03 -0700
To: mm-commits@vger.kernel.org,ruirui.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-update-kdump-reviewer-email-address.patch added to mm-unstable branch
Message-Id: <20260415054805.D373FC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: update Dave's kdump reviewer email address
has been added to the -mm mm-unstable branch.  Its filename is
     maintainers-update-kdump-reviewer-email-address.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-update-kdump-reviewer-email-address.patch

This patch will later appear in the mm-unstable branch at
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
From: Dave Young <ruirui.yang@linux.dev>
Subject: MAINTAINERS: update Dave's kdump reviewer email address
Date: Wed, 15 Apr 2026 11:29:26 +0800

Use my personal email address due to the Red Hat work will stop soon

Link: https://lkml.kernel.org/r/ad8GFhh3SI1wb7IC@darkstar.users.ipa.redhat.com
Signed-off-by: Dave Young <ruirui.yang@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-update-kdump-reviewer-email-address
+++ a/MAINTAINERS
@@ -13789,7 +13789,7 @@ M:	Baoquan He <bhe@redhat.com>
 M:	Mike Rapoport <rppt@kernel.org>
 M:	Pasha Tatashin <pasha.tatashin@soleen.com>
 M:	Pratyush Yadav <pratyush@kernel.org>
-R:	Dave Young <dyoung@redhat.com>
+R:	Dave Young <ruirui.yang@linux.dev>
 L:	kexec@lists.infradead.org
 S:	Maintained
 W:	http://lse.sourceforge.net/kdump/
_

Patches currently in -mm which might be from ruirui.yang@linux.dev are

maintainers-update-kdump-reviewer-email-address.patch

