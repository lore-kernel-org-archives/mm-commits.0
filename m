Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD8897D09D
	for <mm-commits@vger.kernel.org>; Wed, 22 May 2024 07:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716362911; cv=none; b=OkCxsmEjLWDww8P+CFJC5fb93AuOm3wLyVh/0iHdFAwi8RuELDWtn5ABVH7N8GQGUacbEO0ke2QRAF1mp0r7+fxJPf4Rs8QaB3eSicesLPEK1tLeaS/hfwY6LoT8QLGePJ1VlNWQ7F8hDoe12vBd3ABz7YHYuV+Iz1olmnG3uyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716362911; c=relaxed/simple;
	bh=Dt1WQBnjOLz2iS+wEyAmOpn4zcublkb6o9IfnBS85RA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=epm3/4evHQeDssXqeNOqOhE72wEvuUqv3QFejc7l/7vabPHxoA0nq//CEvYCs76K4YW2PItrDFwafDWFajV724rkd9NKuLyhEUv2dpaTF2eBMyJUc/Jc1BhQ080F5qIPrrYh1TCAZja69vayy5AWefLyxKj72vbDs6zahb2WhO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EMu55R+F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EMu55R+F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F16AC2BD11;
	Wed, 22 May 2024 07:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716362910;
	bh=Dt1WQBnjOLz2iS+wEyAmOpn4zcublkb6o9IfnBS85RA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EMu55R+FxoE9+7sFcreJRqaMVqq/jrznLopHEsb8/WKias3zLsAzg+GRDw/S0Nycm
	 BZspklb8+zSB/ioGctcE8ZtEwC3Hnu88RzMnaJM49Wgmg45RTdEk8mggN/CnbVj249
	 fw9fn7GzgvvsI35XJNSpZsFEuhkNO9OR+B4ca47qlWBLU3uTG7zh8uz6SoVNCXQ0Eh
	 6YSgDk4VYxFN2dNKNxbxOSONOOVAFsVPCqqQreuisiP13hdu3tFdkK5xJ+fIqb20gf
	 OQu++FyEe0NutA55vgfhC8HFDw1CWrT6V95nwThUR2M/bKEI2oSCqgaE0EeZa6GhSL
	 N2XGTpKeDUQzQ==
Date: Wed, 22 May 2024 08:28:25 +0100
From: Will Deacon <will@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, rppt@kernel.org, mcgrof@kernel.org,
	klarasmodin@gmail.com, bjorn@kernel.org
Subject: Re: + arm64-patching-fix-handling-of-execmem-addresses.patch added
 to mm-hotfixes-unstable branch
Message-ID: <20240522072825.GA7828@willie-the-truck>
References: <20240521220129.D93AFC2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240521220129.D93AFC2BD11@smtp.kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, May 21, 2024 at 03:01:29PM -0700, Andrew Morton wrote:
> 
> The patch titled
>      Subject: arm64: patching: fix handling of execmem addresses
> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>      arm64-patching-fix-handling-of-execmem-addresses.patch

Thanks, guys!

Will
