Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86D281D8E07
	for <mm-commits@vger.kernel.org>; Fri, 25 Oct 2024 21:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729893446; cv=none; b=sWfa+Ediec7F7xHD0ZkNRYl5ZopZUGdKgSW896T6obuO/uKJ27XN734LIU3tVt7RZGZHVqo1stPqdn3kTI/QUyfERfc2ZEmo37hqBVCd2Qf/P8v0S5/z7mm/4MLALXfV5hz+0VH12CEzGj/SFAUVFJFCRzzJEFiAzZcgNGCzO+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729893446; c=relaxed/simple;
	bh=TboGsHOyD1QdtGw4xFPIiweBLLP4xUnMLisJh0j116w=;
	h=Date:To:From:Subject:Message-Id; b=DcHL69sZZFPP74l2QsJjs3WObS2YuXOJW+jHpcCCW+kLHE69vBZhiY70ws2JOcU84A5abrxYeW843H5mvLi2iJVWu/f5ZyEsFGVWN2P7GK34teTGK7RQGqnw1+dr/113wp8q7g0SRxOOjYvgXR8OJVdnIp5r94e7HD/ZaUIAG8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NY0jjD57; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NY0jjD57"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03EE9C4CEC3;
	Fri, 25 Oct 2024 21:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729893446;
	bh=TboGsHOyD1QdtGw4xFPIiweBLLP4xUnMLisJh0j116w=;
	h=Date:To:From:Subject:From;
	b=NY0jjD57oqi6HE66Ep5DO5T/AGZcQGhD5LYI8aa37WzeJqjgPMXoauCaQ/Oxdc0g0
	 +L6Bmf5Z88pHT2tlK1ykfewKA9zu7QJa8g0tMqxia8imP5dYj/Qn9isOzudXyIIMVq
	 KHKBHjzXRSU7PM3NvQwri7aqxJt50UXCyNSAerYo=
Date: Fri, 25 Oct 2024 14:57:25 -0700
To: mm-commits@vger.kernel.org,qmo@kernel.org,neeraj.upadhyay@kernel.org,matttbe@kernel.org,matt@ranostay.sg,kees@kernel.org,jikos@kernel.org,geliang@kernel.org,elder@kernel.org,davem@davemloft.net,jarkko@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-update-email-addresses.patch added to mm-hotfixes-unstable branch
Message-Id: <20241025215726.03EE9C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: update Jarkko's email addresses
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-update-email-addresses.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-update-email-addresses.patch

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
From: Jarkko Sakkinen <jarkko@kernel.org>
Subject: mailmap: update Jarkko's email addresses
Date: Fri, 25 Oct 2024 21:15:28 +0300

Remove my previous work email, and the new one.  The previous was never
used in the commit log, so there's no good reason to spare it.

Link: https://lkml.kernel.org/r/20241025181530.6151-1-jarkko@kernel.org
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Alex Elder <elder@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Geliang Tang <geliang@kernel.org>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Cc: Matt Ranostay <matt@ranostay.sg>
Cc: Neeraj Upadhyay <neeraj.upadhyay@kernel.org>
Cc: Quentin Monnet <qmo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/.mailmap~mailmap-update-email-addresses
+++ a/.mailmap
@@ -282,7 +282,7 @@ Jan Glauber <jan.glauber@gmail.com> <jgl
 Jan Kuliga <jtkuliga.kdev@gmail.com> <jankul@alatek.krakow.pl>
 Jarkko Sakkinen <jarkko@kernel.org> <jarkko.sakkinen@linux.intel.com>
 Jarkko Sakkinen <jarkko@kernel.org> <jarkko@profian.com>
-Jarkko Sakkinen <jarkko@kernel.org> <jarkko.sakkinen@tuni.fi>
+Jarkko Sakkinen <jarkko@kernel.org> <jarkko.sakkinen@parity.io>
 Jason Gunthorpe <jgg@ziepe.ca> <jgg@mellanox.com>
 Jason Gunthorpe <jgg@ziepe.ca> <jgg@nvidia.com>
 Jason Gunthorpe <jgg@ziepe.ca> <jgunthorpe@obsidianresearch.com>
_

Patches currently in -mm which might be from jarkko@kernel.org are

mailmap-update-email-addresses.patch

