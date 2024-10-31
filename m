Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A12B61BD9E8
	for <mm-commits@vger.kernel.org>; Thu, 31 Oct 2024 03:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730344518; cv=none; b=p+0CzLseluH4ztAD5NfJWyjAHTlV5xlICzJ5ai3jj9FXjFUOBgOdemkkVUvlVkxGjLk8KHX9aDJV9MePylmFVfC1mGOo5qK/DsU+Y0jtzlGyV9Vyx6Dyi9SFGSvmhXIzlTPQmRZEGEUGkvAYmFlxQ2mRKT96Q0Qu8lXqSh5JnOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730344518; c=relaxed/simple;
	bh=UheMYq/bxCO1nhd+uFzFs9cpMKrT0KcH9XA2ago7JFM=;
	h=Date:To:From:Subject:Message-Id; b=RNnROXxnRMvh7BUPLdIOxfsVTTGbEI5OWlTo0pTpIr8V3Q4hlDJjYtb0+P8c4WhZ46dQxl8c3e/2j07OLLwPfzlynOWLhQMNPAP83PeZUw9OWdGiTsQn4zboi+JI2Eo+IzZNdEYusLstfT3/qBC6+7X8Vj4Vf4VD2rDarp2O6u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MlBEUNZj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MlBEUNZj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72A49C4CED0;
	Thu, 31 Oct 2024 03:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730344518;
	bh=UheMYq/bxCO1nhd+uFzFs9cpMKrT0KcH9XA2ago7JFM=;
	h=Date:To:From:Subject:From;
	b=MlBEUNZjmIRVE4E99FjHEd6MuqBsEz227tTeSMxkYPyQs8IWg80LDw64jLDuOGEjn
	 SKMIUdNJ5Mmhp+JRNXqUm0woRMGFSfmXbx75Mthl7LhXVFHBn3zCIOCpwRvgT60Pq7
	 pqe7VOPdPCxxJFrCehTu7+9cuK53zISG0rWmbHg8=
Date: Wed, 30 Oct 2024 20:15:17 -0700
To: mm-commits@vger.kernel.org,qmo@kernel.org,neeraj.upadhyay@kernel.org,matttbe@kernel.org,matt@ranostay.sg,kees@kernel.org,jikos@kernel.org,geliang@kernel.org,elder@kernel.org,davem@davemloft.net,jarkko@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-update-email-addresses.patch removed from -mm tree
Message-Id: <20241031031518.72A49C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: update Jarkko's email addresses
has been removed from the -mm tree.  Its filename was
     mailmap-update-email-addresses.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


