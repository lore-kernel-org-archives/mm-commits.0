Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BD973016EB
	for <mm-commits@vger.kernel.org>; Wed, 15 Apr 2026 05:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776232103; cv=none; b=grCw3GXtha5fRIV/Gfkzsz98FVB6j2nkJ5upgBEh/dKAJtM5KYBrbISmIJbbluf7qILKUPxZJllci8Yz3cAVVsMQcjKJLjH4wChnxX3j9bpANwX6Rn3HfDHMDTTvl+hvCyK2dEJdVxyCcZH6iGb97/WGqAT0Ct8eMbLMBE7DuZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776232103; c=relaxed/simple;
	bh=HZCAfDjQb9skwaIK8Tq8DwOX+M/go2c+F6RaVKwo+fo=;
	h=Date:To:From:Subject:Message-Id; b=FLBitpbeC8E6N+c/lgaZWqNPXq+z8zTpyMXtEyCBgW1bGw3FQOjDmQa4hGlvzpFC2mD5gaFvHtIH5zL97458kO8A8+y4YVDgbrO4gkBBiTpZUf9e6ZK9y1u/4UVXvMPbH8HOXBQ3vAK/YKJwEQf5lhpiop9AV0NC3qzE7O9F5GI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gTX1DB+2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gTX1DB+2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E905C19424;
	Wed, 15 Apr 2026 05:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776232103;
	bh=HZCAfDjQb9skwaIK8Tq8DwOX+M/go2c+F6RaVKwo+fo=;
	h=Date:To:From:Subject:From;
	b=gTX1DB+2GW2jcraDnqrZ/DB3n1UIBSKK0vOfnparjZI0OBxcoHiJ/tp6uPlcNaI/F
	 Zw/CdS+sB3tv5MZtsSKAzDg6nrGsIdiqisTDVOKXjyalSI2JeELRSCR+3b3ef2aeiG
	 GHaYNW21+0TiUE5gOmIUMGRnvy8tpmZCXib+xUHU=
Date: Tue, 14 Apr 2026 22:48:19 -0700
To: mm-commits@vger.kernel.org,dyoung@redhat.com,ruirui.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-update-kdump-reviewer-email-address.patch added to mm-unstable branch
Message-Id: <20260415054822.9E905C19424@smtp.kernel.org>
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
Acked-by: Dave Young <dyoung@redhat.com>
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

