Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9CAD1D12FA
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 00:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725238787; cv=none; b=irs/DC+0JXS1R2MOKj7QzF2gk58l6MGnK4r17Xeklkyg1W2SdwMxyJixpzSupQE047Y1s9KW5iXudsG1wYlmPFFDLVxmUbJd5lPvpyFo1R9x37FwNPsIdm8ViNzjEqXOCUPMGtzTwQ09BMBSuiIH+PjUPqe1+9b1UIGHL6oARUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725238787; c=relaxed/simple;
	bh=0nywO5Nq1gfWh9SjB1RiDIGZTt00keGL857T5ge6C5U=;
	h=Date:To:From:Subject:Message-Id; b=bN9UvNvSLRCWEKOwiN36jFzgj0rer7jPPm+RkZJZ6D6wDGg3kFiYZ4D7LW/XVJdKJg/fcC/3wtpPwaeTh3DgGfDeIeK+2iyeYHunEmjp353/rvtWJxZDG9jXGznpRFF/gTNMY7l70OsIqAECyfnESF8Cfe2uV90TAi2mS0ehtRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Yize9T4Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Yize9T4Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4AF6C4CEC3;
	Mon,  2 Sep 2024 00:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725238787;
	bh=0nywO5Nq1gfWh9SjB1RiDIGZTt00keGL857T5ge6C5U=;
	h=Date:To:From:Subject:From;
	b=Yize9T4QCAmW/YUErkNOCBbgxz+Xq1rugWh+femt4yd5yFempIYptfjzK6leAcUfV
	 W7lEIUBTeGVw5Kb+xq2ztjaFP8QO5n1OBC9bu4rZBdpkKHTo0kySk7J/QkhS3rp/pe
	 gdq1gsqQU0pF62+ncv2MCUBJ6AsBbir5CbCwEuoU=
Date: Sun, 01 Sep 2024 17:59:47 -0700
To: mm-commits@vger.kernel.org,matttbe@kernel.org,davem@davemloft.net,jankul@alatek.krakow.pl,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-update-entry-for-jan-kuliga.patch removed from -mm tree
Message-Id: <20240902005947.A4AF6C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: update entry for Jan Kuliga
has been removed from the -mm tree.  Its filename was
     mailmap-update-entry-for-jan-kuliga.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jan Kuliga <jankul@alatek.krakow.pl>
Subject: mailmap: update entry for Jan Kuliga
Date: Fri, 30 Aug 2024 11:56:58 +0200

Soon I won't be able to use my current email address.

Link: https://lkml.kernel.org/r/20240830095658.1203198-1-jankul@alatek.krakow.pl
Signed-off-by: Jan Kuliga <jankul@alatek.krakow.pl>
Cc: David S. Miller <davem@davemloft.net>
Cc: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-entry-for-jan-kuliga
+++ a/.mailmap
@@ -269,6 +269,7 @@ James Ketrenos <jketreno@io.(none)>
 Jan Glauber <jan.glauber@gmail.com> <jang@de.ibm.com>
 Jan Glauber <jan.glauber@gmail.com> <jang@linux.vnet.ibm.com>
 Jan Glauber <jan.glauber@gmail.com> <jglauber@cavium.com>
+Jan Kuliga <jtkuliga.kdev@gmail.com> <jankul@alatek.krakow.pl>
 Jarkko Sakkinen <jarkko@kernel.org> <jarkko.sakkinen@linux.intel.com>
 Jarkko Sakkinen <jarkko@kernel.org> <jarkko@profian.com>
 Jarkko Sakkinen <jarkko@kernel.org> <jarkko.sakkinen@tuni.fi>
_

Patches currently in -mm which might be from jankul@alatek.krakow.pl are


