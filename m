Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D2A13BAF8
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708645221; cv=none; b=K97MTDVaoQOan9YrmboTEio/OyD+WZuQbFUAzYhQ3crsStnGR6HLZ9Q7A0pVyfsJKPAOhEijMF6FLp2bNTHvg1a39iwScaPb/sJtz7WoQQfL0Cj4SUs5/bTQD1mccbtxFa7kZc6jJTot6kutb0ANqAjDXlvfRwfFWQ4sq0ZdjNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708645221; c=relaxed/simple;
	bh=lbkBeFCjuJd0Ogs0bESUJVjuN0l9fnFWh3uhtI2gsRI=;
	h=Date:To:From:Subject:Message-Id; b=aYrzMJZBhnhhmOLtdRCblahC1kA50dcFN6l9LAGW87XhMD+pHgCNmmae9igU4U5ArfX2Hi/UBdncCkHdS3O6eZbF/MmfqHy16muOz36MZZvNz62O8OKWl86amXSbsUMZ/kygjCyAMCX8pm53oWDhLpAkzQpB/w9CZThMPRmWlCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JmcFotzr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JmcFotzr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7996FC433C7;
	Thu, 22 Feb 2024 23:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708645221;
	bh=lbkBeFCjuJd0Ogs0bESUJVjuN0l9fnFWh3uhtI2gsRI=;
	h=Date:To:From:Subject:From;
	b=JmcFotzrv0BMveOTcswtZHprYScFCcwih+obaGsP8Y5Ieq04+ICnBiCJPIYU0+2ht
	 Ow2djr6qGNcp/VsgRn05Le3USNIJ82xcQIympbw+Xnk6fCM7tlCTcDpvWqEgd0AxRW
	 FaXZ/pnCRqACqcODZ0H+wA3sD6NBa2TdX8bMmc/4=
Date: Thu, 22 Feb 2024 15:40:20 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] nilfs2-maintainers-drop-unreachable-project-mirror-site.patch removed from -mm tree
Message-Id: <20240222234021.7996FC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: MAINTAINERS: drop unreachable project mirror site
has been removed from the -mm tree.  Its filename was
     nilfs2-maintainers-drop-unreachable-project-mirror-site.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: MAINTAINERS: drop unreachable project mirror site
Date: Thu, 8 Feb 2024 18:30:18 +0900

The hosting site where the nilfs project had a mirror site continues to be
in trouble, so we have decided not to use that site.  This will reflect it
in the MAINTAINERS file.

Link: https://lkml.kernel.org/r/20240208093018.6334-1-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

--- a/MAINTAINERS~nilfs2-maintainers-drop-unreachable-project-mirror-site
+++ a/MAINTAINERS
@@ -15435,7 +15435,6 @@ M:	Ryusuke Konishi <konishi.ryusuke@gmai
 L:	linux-nilfs@vger.kernel.org
 S:	Supported
 W:	https://nilfs.sourceforge.io/
-W:	https://nilfs.osdn.jp/
 T:	git https://github.com/konis/nilfs2.git
 F:	Documentation/filesystems/nilfs2.rst
 F:	fs/nilfs2/
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are


