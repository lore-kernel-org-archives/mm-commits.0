Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 523FFC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 01:40:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233688AbiANBkx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 Jan 2022 20:40:53 -0500
Received: from gandalf.ozlabs.org ([150.107.74.76]:40217 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233397AbiANBkx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jan 2022 20:40:53 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4JZkXM4YSqz4xdl;
        Fri, 14 Jan 2022 12:40:51 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1642124452;
        bh=jJp4bHBX1eWi68FTrFV8tpsKsLKyn6d249KTDv34+c4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WKNF09dWPrrGoM7G00dBVaFsk0bhF77MNYC5rIKDg6UsGugH6uiFxm3MRQxcU/aXe
         WYcpKiPGtEzPsmu7xRzXyZ8ytu2s0naYcOVusdJ5CED0CX1dq0Dn0hkBag/XJHAdGS
         bPNtxLawO6Jt6JXx77L7cQbrlC3Ofy6Q2FGiTyfsePUZoLTkEPwZww/WvWlhB3kkna
         WNaXAXSM7RqNp9TQXA7DKvbIKiNO3lkvrKuDvsyXFIUZBBndNvnNKFICOKtr9D06a+
         wDK/jH6zCwrA8EOK8qzcGrtD57JflLlCUsFDhXCc7gsMAvYMCk//GOCq3GqHtx9Afm
         Tm6JklPc1A3Hw==
Date:   Fri, 14 Jan 2022 12:40:50 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     akpm@linux-foundation.org
Cc:     andreyknvl@gmail.com, mm-commits@vger.kernel.org,
        wangkefeng.wang@huawei.com
Subject: Re: +
 mm-defer-kmemleak-object-creation-of-module_alloc-v4-fix.patch added to -mm
 tree
Message-ID: <20220114124050.57e1c9b8@canb.auug.org.au>
In-Reply-To: <20220113202033.8CMmXQsBw%akpm@linux-foundation.org>
References: <20220113202033.8CMmXQsBw%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/RMN/e+u5dr3_W_I9hzPfY5Y";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_/RMN/e+u5dr3_W_I9hzPfY5Y
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Thu, 13 Jan 2022 12:20:33 -0800 akpm@linux-foundation.org wrote:
>
> The patch titled
>      Subject: mm-defer-kmemleak-object-creation-of-module_alloc-v4-fix
> has been added to the -mm tree.  Its filename is
>      mm-defer-kmemleak-object-creation-of-module_alloc-v4-fix.patch

Added to linux-next today.

--=20
Cheers,
Stephen Rothwell

--Sig_/RMN/e+u5dr3_W_I9hzPfY5Y
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmHg1KIACgkQAVBC80lX
0GzgTgf9EEMcfK5LWmqdK+El/YiTfrQbJumbgp19uoz9aStDyCmj1MwnY+8YSK8R
5irbZrltAF8KAU981KAJtCnTblZsakornX3OWq/KKcFB+bjKO7WmpXzIhvLI8pPK
CtEj7d47ymjyv21a1V+D9eX4K8wMSF07ZTgPiXCNbJbDW7ua+ZuG6kRH90U9GB/u
tNV3Qwi1z/ebZ99TAl339tC0to1XBvVmZY8/vmI5SSJws0jjxN4AA6mVUGYmLnyD
A1YYq2gzIBrq621AE6P38JoH9rRt3AUX8+mpEOYnw+ax91GvVR32lxc1GR9KYYxt
dcpZPPNBDTgLKem7UgJ6h9NiUq/yFg==
=mn4Q
-----END PGP SIGNATURE-----

--Sig_/RMN/e+u5dr3_W_I9hzPfY5Y--
